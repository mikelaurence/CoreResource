//
//  CoreModel.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreManager.h"
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
        id data = [self dataCollectionFromDeserializedCollection:deserialized];
        if (data != nil) {
            else if ([deserialized isKindOfClass:NSDictionary])
                return [NSArray arrayWithObject:[self createOrUpdateFromDictionary:deserialized]];
            else if ([deserialized isKindOfClass:NSArray]) {
                NSMutableArray *array = [NSMutableArray arrayWithCapacity:[(NSArray*)deserialized count]];
                for (NSDictionary *dict in (NSArray*)deserialized) {
                    id obj = [self createOrUpdateFromDictionary:dict];
                    if (obj != nil)
                        [array addObject:obj];
                }
                return array;
            }
        }
    }
    return nil;
}

/**
    Retrieves the actual data collection from the initial deserialized collection.
    This should be used if your response has its data objects nested, e.g.:
    
    { results: [{ name: 'Mike' }, { name: 'Mork' }] }
    
    Defaults to just returning the initial collection, which would work if you have no nested-ness, e.g.:
    
    [{ name: 'Mike' }, { name: 'Mork' }]
*/
+ (id) dataCollectionFromDeserializedCollection:(id)deserializedCollection {
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
	
	// If appropriate, configure the new managed object.
	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
}

+ (id) createOrUpdateFromDictionary:(NSDictionary*)dict {
    
    // Attempt to find existing record by using ById fetch template
    NSFetchRequest* fetch = [[[self coreManager] managedObjectModel] fetchRequestFromTemplateWithName:
        [NSString stringWithFormat:@"%@ById", self] substitutionVariables:
        [NSDictionary dictionaryWithObject:[dict objectForKey:[self remoteIdField]] forKey:@"id"];
    ];
    [fetch setFetchLimit:1];

    NSError* fetchError = nil;
    NSMutableArray* fetchResults = [[[[self coreManager] managedObjectContext] executeFetchRequest:fetch error:&fetchError] mutableCopy];

    if (fetchError == nil) {
        // If there is a result, check to see whether we should update it or not
        if ([fetchResults count] > 0) {
            RemoteModel* existingObject = [fetchResults objectAtIndex:0];
            if ([existingObject shouldUpdateWithData:dict]) {
                
                // Result is newer than fetched object, so update it
                NSLog(@"%@ needs update [old: %@, new: %@]", [existingObject id], [existingObject updated_at], 
                    [[MainDelegate dataDateParser] dateFromString:[result objectForKey:@"updated"]]);
            }
            else {
                //NSLog(@"%@ up-to-date", [existingObject id]);
            }

        }
        
        // Otherwise, just create a new object
        else {
            NSManagedObject* newObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
            [newObject performSelector: @selector(setAttributesFromJson:) withObject:result];
            NSLog(@"Created new object (#%@)", resultId);
        }
    }
    else {
        NSLog(@"Error in fetching %@ for update comparison. %@", [self modelName], [fetchError localizedDescription]);
    }
}

/**
    Determines whether or not an existing (local) record should be updated with data from the provided dictionary
    (presumably retrieved from a remote source.) The most likely determinant would be if the new data is newer
    than the object.
*/
- (BOOL) shouldUpdateWithData: (NSDictionary*) data { 
    return [(NSDate*)updated_at compare:[self dateParserForField:@"updated_at"]] == NSOrderedAscending;
}


#pragma mark -
#pragma mark Read

+ (id) find:(NSString*)recordId {

}

+ (id) findAll:(id)parameters {


}

+ (id) findLocal:(NSString*)recordId {

}

+ (id) findAllLocal:(id)parameters {

}

+ (id) findRemote:(NSString*)recordId {

}

+ (id) findAllRemote:(id)parameters {
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:
        [CoreUtils URLFromSite:[self remoteSiteURL] andParameters:parameters];
    request.delegate = self;
    request.didFinishSelector = @selector(findRemoteDidFinish);
    request.didFailSelector = @selector(findRemoteDidFail:);
}

+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request {
    id deserializedResources = [self deserializeFromString:[request responseString]];
}

+ (void) findRemoteDidFail:(ASIHTTPRequest*)request {
    NSLog(@"[%@#findRemoteDidFail] Find request failed: %@", self, request);
}

#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest) fetchRequest {
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[self entityDescription]];
    return fetchRequest;
}

+ (NSFetchRequest) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate {
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
        managedObjectContext:managedObjectContext 
        sectionNameKeyPath:sectionKey 
        cacheName:@"Root"] autorelease];
    coreResultsController.entityClass = self;
    return coreResultsController;
}



@end

