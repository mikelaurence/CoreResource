//
//  CoreDeserializer.m
//  Core Resource
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence.
//

#import "CoreDeserializer.h"
#import "CoreResult.h"
#import "NSObject+Core.h"
#import "SBJsonParser.h"


@implementation CoreDeserializer

static NSArray* allowedFormats;

@synthesize source, resourceClass, format, coreManager;
@synthesize target, action;


- (id) initWithSource:(id)sourceObj andResourceClass:(Class)clazz {
    if (self = [super init]) {
        self.source = sourceObj;
        self.resourceClass = clazz;
    }
    return self;
}


- (void) main {
    // Use format to change deserialization class and convert serialized string into resources
    Class newClass = [resourceClass performSelector:@selector(deserializerClassForFormat:) withObject:[self format]];
    if (newClass != nil) {

        // Change runtime class (in order to capture correct resourcesFromString method)
        self->isa = newClass;
            
        // Get Core Manager from resource class if it hasn't been defined yet
        if (coreManager == nil)
            coreManager = [resourceClass performSelector:@selector(coreManager)];

        // Create "scratchpad" object context; we will merge this context into the main context once deserialization is complete
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:[coreManager persistentStoreCoordinator]];
        [[NSNotificationCenter defaultCenter] addObserver:self 
            selector:@selector(contextDidSave:) 
            name:NSManagedObjectContextDidSaveNotification 
            object:managedObjectContext];
            
        resources = [[self resourcesFromString:[self sourceString]] retain];
        
        // Attempt to save object context; if there's an error, it will be placed in the CoreResult (which is sent to the target)
        [managedObjectContext save:&error];
            
        // Remove context save observer
        [[NSNotificationCenter defaultCenter] removeObserver:self 
            name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    }
    else {
        error = [[[NSError alloc] initWithDomain:$S(@"Couldn't deserialize with format '%@'", format) code:0 userInfo:nil] retain];
    }
        
    // Perform action on target if possible
    if (target && action && [target respondsToSelector:action]) {
        CoreResult *result = error != nil ?
            [[CoreResult alloc] initWithResources:resources] :
            [[CoreResult alloc] initWithError:error];
        [target performSelector:action withObject:result];
        [result release];
    }
}


/**
    When the context saves, send a message to our Core Manager to merge in the updated data
*/
- (void)contextDidSave:(NSNotification*)notification {
    [coreManager performSelectorOnMainThread:@selector(mergeContext:) 
        withObject:notification 
        waitUntilDone:NO];
}



#pragma mark -
#pragma mark Source

- (NSString*) sourceString {
    if (sourceString == nil) {
        NSString* rawString = [source isKindOfClass:[NSString class]] ? source : [source get:@selector(responseString)];
        sourceString = [[rawString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] retain];
    }
    return sourceString;
}



#pragma mark -
#pragma mark Format determination

- (NSString*) format {
    if (format != nil)
        return format;

    if (allowedFormats == nil)
        allowedFormats = [$A(@"json", @"xml") retain];
    
    // Attempt to determine format using response content type
    if (format == nil)
        format = [self formatFromHeader:@"Content-Type" inDictionary:@selector(responseHeaders)];
        
    // Attempt to determine format using request accept header
    if (format == nil)
        format = [self formatFromHeader:@"Accept" inDictionary:@selector(requestHeaders)];
        
    // Attempt to determine format using URL extension
    if (format == nil) {
        NSURL *url = [source get:@selector(url)];
        if (url != nil)
            format = [self allowedFormatsFromString:[url relativePath]];
    }
    
    // Attempt to determine format by looking at first content character
    if (format == nil) {
        NSString* firstContentChar = [[self sourceString] substringToIndex:0];
        if ([firstContentChar isEqualToString:@"<"])
            return @"xml";
        if ([firstContentChar isEqualToString:@"{"] || [firstContentChar isEqualToString:@"["])
            return @"json";
    }
    
    return format;
}

- (NSString*) formatFromHeader:(NSString*)header inDictionary:(SEL)dictionarySelector {
    NSDictionary *headers = [source get:dictionarySelector];
    if (headers != nil) {
        NSString *headerValue = [headers objectForKey:header];
        if (headerValue != nil)
            return [self allowedFormatsFromString:headerValue];
    }
    return nil;
}

- (NSString*) allowedFormatsFromString:(NSString*)string {
    for (NSString* allowedFormat in allowedFormats) {
        if ([string rangeOfString:allowedFormat options:NSCaseInsensitiveSearch].location != NSNotFound)
            return allowedFormat;
    }
    return nil;
}


#pragma mark -
#pragma mark Deserialization

/**
    Override in subclasses
*/
- (id) resourcesFromString:(NSString*)string { return nil; }


#pragma mark -
#pragma mark Lifecycle end

- (void) dealloc {
    [source release];
    [sourceString release];
    [format release];
    [coreManager release];
    [managedObjectContext release];
    [error release];
    [resources release];
    [target release];
    [super dealloc];
}

@end



#pragma mark -
#pragma mark Format deserializers

#ifdef SBJsonParser

@implementation CoreJSONDeserializer

- (id) resourcesFromString:(NSString*)string {

    // Deserialize JSON
    SBJsonParser *jsonParser = [SBJsonParser new];
    id jsonData = [jsonParser objectWithString:string];
    if (jsonData == nil) { // Record error and return if JSON parsing failed
        error = [[[NSError alloc] initWithDomain:$S(@"JSON parsing failed: %@", [jsonParser errorTrace]) code:0 userInfo:nil] retain];
        return nil;
    }
    
    return [self resourcesFromJSONData:jsonData];
}

- (id) resourcesFromJSONData:(id)jsonData {
    // Convert raw JSON to resource data parsable by CoreResource create/update methods
    id resourceData = [self resourceDataFromJSONData:jsonData];
    
    // Create/update resources
    return [resourceClass performSelector:@selector(create:withOptions:)
        withObject:resourceData withObject:$D($B(NO), @"timestamp")];
}        

- (id) resourceDataFromJSONData:(id)jsonData {

    // COLLAPSE JSON

    // Turn collection into array if not already one
    NSArray* jsonArray = [jsonData isKindOfClass:[NSDictionary class]] ? jsonData : $A(jsonData);

    if (jsonArray != nil) {
        NSMutableArray *jsonResources = [NSMutableArray arrayWithCapacity:[jsonArray count]]; // Container for deserialized resources
        if (coreManager.logLevel > 1)
            NSLog(@"Deserializing %@ %@", [NSNumber numberWithInt:[jsonArray count]], [resourceClass performSelector:@selector(remoteCollectionName)]);

        // Iterate through JSON elements and attempt to create/update resources for each
        for (id jsonElement in jsonArray) {
            id properties = [resourceClass performSelector:@selector(resourcePropertiesFromJSONElement:withParent:)
                    withObject:jsonElement withObject:nil];
            id resource = [resourceClass performSelector:@selector(createOrUpdateWithDictionary:andOptions:)
                withObject:properties withObject:$D(managedObjectContext, @"context")];
            if (resource != nil)
                [jsonResources addObject:resource];
        }
        return jsonResources;
    }
    
    return nil;
}

@end

#endif

#ifdef DDXMLDocument

@implementation CoreXMLDeserializer

- (NSArray*) resourcesFromString:(NSString*)string {

    // Deserialize XML
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithXMLString:string options:0 error:&error];
    
    return nil;
}

@end

#endif

