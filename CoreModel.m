//
//  CoreModel.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreModel.h"
#import "CoreUtils.h"
#import "JSON.h"

@implementation CoreModel

#pragma mark -
#pragma mark Configuration

+ (CoreManager*) coreManager {
    return [CoreManager main];
}

+ (NSString*) remoteSiteURL {
    return [[self coreManager] remoteSiteURL];
}

+ (NSString*) remoteCollectionName {
    return [[NSStringFromClass(self) deCamelizeWith:@"_"] stringByAppendingString:@"s"];
}

+ (NSString*) remoteCollectionURLForAction:(Action)action {
    return [NSString stringWithFormat:@"%@/%@", [self remoteSiteURL], [self remoteCollectionName]];
}

- (NSString*) remoteResourceURLForAction:(Action)action {
    return [NSString stringWithFormat:@"%@/%@/%@", [[self class] remoteSiteURL], [[self class] remoteCollectionName]]; 
}


#pragma mark -
#pragma mark Serialization

+ (NSString*) localIdField {
    return @"recordId";
}

+ (NSString*) remoteIdField {
    return @"id";
}

+ (NSDateFormatter*) dateParser {
    return [[self coreManager] defaultDateParser];
}

+ (NSDateFormatter*) dateParserForField:(NSString*)field {
    return [self dateParser];
}

+ (NSArray*) deserializeFromString:(NSString*)serializedString {
    id deserialized = [serializedString JSONValue];
    if (deserialized != nil) {
        // Turn into array if not already one
        if ([deserialized isKindOfClass:[NSDictionary class]])
            deserialized = [NSArray arrayWithObject:deserialized];

        NSArray* data = [self dataCollectionFromDeserializedCollection:deserialized];
        if (data != nil) {
            NSMutableArray *objs = [NSMutableArray arrayWithCapacity:[(NSArray*)data count]];
            for (NSDictionary *dict in (NSArray*)deserialized) {
                id obj = [self createOrUpdateWithDictionary:dict];
                if (obj != nil)
                    [objs addObject:obj];
            }
            return objs;
        }
    }
    return nil;
}

/**
    Retrieves the actual data collection from the initial deserialized collection.
    This should be used, for example. if your response has its data objects nested, e.g.:
    
    { results: [{ name: 'Mike' }, { name: 'Mork' }] }
    
    It could also just be used to fine-tune the deserialized data before it's converted to model objects.
    
    Defaults to just returning the initial collection, which would work if you have no nested-ness, e.g.:
    
    [{ name: 'Mike' }, { name: 'Mork' }]
*/
+ (NSArray*) dataCollectionFromDeserializedCollection:(id)deserializedCollection {
    return deserializedCollection;
}



#pragma mark -
#pragma mark Core Data Basics

+ (NSString*) entityName {
    return [NSString stringWithFormat:@"%@", self];
}

+ (NSEntityDescription*) entityDescription {
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[[self coreManager] managedObjectContext]];
}


#pragma mark -
#pragma mark Create

+ (id) create: (id)parameters {
	
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [[self coreManager] managedObjectContext];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
    return newManagedObject;
}

+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict {
    
    // Attempt to find existing record by using ById fetch template
    NSFetchRequest* fetch = [[[self coreManager] managedObjectModel] 
        fetchRequestFromTemplateWithName:[NSString stringWithFormat:@"%@ById", self] 
        substitutionVariables:[NSDictionary dictionaryWithObject:[dict objectForKey:[self remoteIdField]] forKey:@"id"]
    ];
    [fetch setFetchLimit:1];

    NSError* fetchError = nil;
    NSMutableArray* fetchResults = [[[[self coreManager] managedObjectContext] executeFetchRequest:fetch error:&fetchError] mutableCopy];

    if (fetchError == nil) {
        // If there is a result, check to see whether we should update it or not
        if ([fetchResults count] > 0) {
            CoreModel *existingObject = [fetchResults objectAtIndex:0];
            if ([existingObject shouldUpdateWithDictionary:dict]) {
                // Result is newer than fetched object, so update it
                NSLog(@"%@ needs update [old: %@, new: %@]", existingObject, dict);
            }
            else {
                NSLog(@"%@ up-to-date", existingObject);
            }
            return existingObject;
        }
        
        // No existing record found, so create a new object
        else {
            CoreModel *newObject = [[self alloc] initWithEntity:[self entityDescription] 
                insertIntoManagedObjectContext:[[self coreManager] managedObjectContext]];
            [newObject updateWithDictionary:dict];
            NSLog(@"Created new object (#%@)", newObject);
            return newObject;
        }
    }
    else {
        NSLog(@"Error in fetching with dictionary %@ for update comparison: %@", dict, [fetchError localizedDescription]);
    }
    
    return nil;
}

/**
    Determines whether or not an existing (local) record should be updated with data from the provided dictionary
    (presumably retrieved from a remote source.) The most likely determinant would be if the new data is newer
    than the object.
*/
- (BOOL) shouldUpdateWithDictionary:(NSDictionary*)dict { 
    if ([self respondsToSelector:@selector(updated_at)]) {
        return [(NSDate*)[self performSelector:@selector(updated_at)] compare:
            [[[self class] dateParserForField:@"updated_at"] dateFromString:[dict objectForKey:@"updated_at"]]] == NSOrderedAscending;
    }
    else
        return YES;
}

- (void) updateWithDictionary:(NSDictionary*)dict {
    // Loop through and apply fields in dictionary
    for (NSString* field in [dict allKeys]) {
        id value = [dict objectForKey:field];
        
        NSMethodSignature* fieldSignature = [[self class] instanceMethodSignatureForSelector:NSSelectorFromString(field)];
        if (fieldSignature != nil) {
            NSString* returnType = [[NSString alloc] initWithCString:[fieldSignature methodReturnType]];
            NSLog(@"Return type for %@ is %@", field, returnType);
            //if ([returnType isEqualToString:@"double"])
            [self setValue:value forKey:field];
        }
    }
}


#pragma mark -
#pragma mark Read

+ (id) find:(NSString*)recordId {
    return nil;
}

+ (id) findAll:(id)parameters {
    return nil;
}

+ (id) findLocal:(NSString*)recordId {
    return nil;
}

+ (id) findAllLocal:(id)parameters {
    return nil;
}

+ (void) findRemote:(NSString*)recordId {
    [self findAllRemote:[NSString stringWithFormat:@"%@=%@", [self remoteIdField], recordId]];
}

+ (void) findAllRemote:(id)parameters {
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:
        [CoreUtils URLWithSite:[self remoteCollectionURLForAction:Read] andFormat:@"json" andParameters:parameters]];
    request.delegate = self;
    request.didFinishSelector = @selector(findRemoteDidFinish);
    request.didFailSelector = @selector(findRemoteDidFail:);
    [[[self coreManager] requestQueue] addOperation:request];
}

+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request {
    [self deserializeFromString:[request responseString]];
}

+ (void) findRemoteDidFail:(ASIHTTPRequest*)request {
    NSLog(@"[%@#findRemoteDidFail] Find request failed: %@", self, request);
}

#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest*) fetchRequest {
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[self entityDescription]];
    return fetchRequest;
}

+ (NSFetchRequest*) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate {
    NSFetchRequest *fetchRequest = [self fetchRequest];
    [fetchRequest setSortDescriptors:[CoreUtils sortDescriptorsFromString:sorting]];
    [fetchRequest setPredicate:predicate];
    return fetchRequest;
}

+ (CoreResultsController*) coreResultsControllerWithSort:(NSString*)sorting andSectionKey:(NSString*)sectionKey {
    NSFetchRequest *fetchRequest = [self fetchRequestWithSort:sorting andPredicate:nil];
    return [self coreResultsControllerWithRequest:fetchRequest andSectionKey:sectionKey];
}

+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey {
    CoreResultsController* coreResultsController = [[[CoreResultsController alloc] initWithFetchRequest:fetchRequest 
        managedObjectContext:[[self coreManager] managedObjectContext] 
        sectionNameKeyPath:sectionKey 
        cacheName:@"Root"] autorelease];
    coreResultsController.entityClass = self;
    return coreResultsController;
}



@end

