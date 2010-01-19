//
//  CoreModel.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreModel.h"
#import "CoreUtils.h"
#import "CoreRequest.h"
#import "CoreResult.h"
#import "JSON.h"
#import "NSString+InflectionSupport.h"

@implementation CoreModel

#pragma mark -
#pragma mark Configuration

+ (CoreManager*) coreManager {
    return [CoreManager main];
}

+ (BOOL) useBundleRequests {
    return [[self coreManager] useBundleRequests];
}

+ (NSString*) remoteSiteURL {
    return [[self coreManager] remoteSiteURL];
}

+ (NSString*) remoteCollectionName {
    return [[[NSStringFromClass(self) deCamelizeWith:@"_"] substringFromIndex:1] stringByAppendingString:@"s"];
}

+ (NSString*) remoteCollectionURLForAction:(Action)action {
    return [NSString stringWithFormat:@"%@/%@", [self remoteSiteURL], [self remoteCollectionName]];
}

- (NSString*) remoteResourceURLForAction:(Action)action {
    return [NSString stringWithFormat:@"%@/%@/%@", [[self class] remoteSiteURL], [[self class] remoteCollectionName]]; 
}

+ (NSString*) bundleCollectionPathForAction:(Action)action {
    return [NSString stringWithFormat:@"%@", [self remoteSiteURL], [self remoteCollectionName]];
}

- (NSString*) bundleResourcePathForAction:(Action)action {
    return [NSString stringWithFormat:@"%@.%@", [[self class] remoteCollectionName]];
}


/**
    Returns the class type for a given property in a given model.
    By default, this caches the resulting dictionaries provided by Core Data
    in order to maximize efficiency.
*/
+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field inModel:(Class)modelClass {
    NSDictionary *modelTypes = [[[CoreManager main] modelPropertyTypes] objectForKey:modelClass];
    
    // Create entry for the given class if it doesn't exist yet
    if (modelTypes == nil) {
        modelTypes = [NSDictionary dictionary];
        [[[CoreManager main] modelPropertyTypes] setObject:[[self entityDescription] propertiesByName] forKey:modelClass];
        
        // Also add relationships dictionary
        [[[CoreManager main] modelRelationships] setObject:[[self entityDescription] relationshipsByName] forKey:modelClass];
    }

    return [modelTypes objectForKey:field];
}

+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field {
    return [self propertyDescriptionForField:field inModel:self];
}


#pragma mark -
#pragma mark Serialization

+ (NSString*) localNameForRemoteField:(NSString*)name {
    return name;
}

+ (NSString*) remoteNameForLocalField:(NSString*)name {
    return name;
}

+ (NSString*) localIdField {
    return @"resourceId";
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
    //NSLog(@"Serialized data: %@", serializedString);
    id deserialized = [serializedString JSONValue];
    if (deserialized != nil) {
        // Turn into array if not already one
        if ([deserialized isKindOfClass:[NSDictionary class]])
            deserialized = [NSArray arrayWithObject:deserialized];

        NSArray* data = [self dataCollectionFromDeserializedCollection:deserialized];
        if (data != nil) {
            NSLog(@"Deserializing %@ %@", [NSNumber numberWithInt:[deserialized count]], [self remoteCollectionName]);
            NSMutableArray *objs = [NSMutableArray arrayWithCapacity:[(NSArray*)data count]];
            for (NSMutableDictionary *dict in (NSArray*)deserialized) {
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
#pragma mark Core Data

+ (NSString*) entityName {
    return [NSString stringWithFormat:@"%@", self];
}

+ (NSEntityDescription*) entityDescription {
    return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:[[self coreManager] managedObjectContext]];
}

+ (BOOL) hasRelationships {
    return [(NSDictionary*)[[[[self class] coreManager] modelRelationships] objectForKey:self] count] > 0;
}

+ (NSManagedObjectContext*) managedObjectContext {
    return [[self coreManager] managedObjectContext];
}


#pragma mark -
#pragma mark Create

+ (id) create:(id)parameters {
	
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
    if (fetch == nil)
        [NSException raise:@"No finder template available" 
            format:@"No fetch request template could be found for entity %@. Please implement the template '%@' in your Core Data model (xcdatamodel file).",
            self, [NSString stringWithFormat:@"%@ById", self]];
    [fetch setFetchLimit:1];

    NSError* fetchError = nil;
    NSMutableArray* fetchResults = [[[[self coreManager] managedObjectContext] executeFetchRequest:fetch error:&fetchError] mutableCopy];

    if (fetchError == nil) {
        // If there is a result, check to see whether we should update it or not
        if ([fetchResults count] > 0) {
            CoreModel *existingObject = [fetchResults objectAtIndex:0];
            [existingObject updateWithDictionary:dict];
            return existingObject;
        }
        
        // No existing record found, so create a new object
        else {
            CoreModel *newObject = [[self alloc] initWithEntity:[self entityDescription] 
                insertIntoManagedObjectContext:[[self coreManager] managedObjectContext]];
            [newObject updateWithDictionary:dict];
            NSLog(@"Created new %@ with id %@", self, [newObject valueForKey:[self localIdField]]);
            return newObject;
        }
    }
    else {
        NSLog(@"Error in fetching with dictionary %@ for update comparison: %@", dict, [fetchError localizedDescription]);
    }
    
    return nil;
}

+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict andRelationship:(NSRelationshipDescription*)relationship toObject:(CoreModel*)object {
    id otherObject = [self createOrUpdateWithDictionary:dict];
    if (otherObject)
        [otherObject setValue:object forKey:[relationship name]];
    return otherObject;
}


/**
    Determines whether or not an existing (local) record should be updated with data from the provided dictionary
    (presumably retrieved from a remote source.) The most likely determinant would be if the new data is newer
    than the object.
*/
- (BOOL) shouldUpdateWithDictionary:(NSDictionary*)dict { 
    if ([self respondsToSelector:@selector(updated_at)]) {
        NSDate *updatedAt = (NSDate*)[self performSelector:@selector(updated_at)];
        if (updatedAt != nil) {
            return [updatedAt compare:
                [[[self class] dateParserForField:@"updated_at"] dateFromString:[dict objectForKey:@"updated_at"]]] == NSOrderedAscending;
        }
    }
    return YES;
}

- (void) updateWithDictionary:(NSDictionary*)dict {

    // Determine whether this object needs to be updated (relationships will still be checked no matter what)
    BOOL shouldUpdateRoot = [self shouldUpdateWithDictionary:dict];
    if (shouldUpdateRoot)
        NSLog(@"Updating %@ with id %@", [self class], [self valueForKey:[[self class] localIdField]]);
    else {
        NSLog(@"Skipping update of %@ with id %@ because it is already up-to-date", [self class], [self valueForKey:[[self class] localIdField]]);
        // If we won't be updating the root object and there are no relationships, cancel out for efficiency's sake
        if (![[self class] hasRelationships])
            return;
    }

    // Mutable-ize dictionary if necessary
    if (![dict isKindOfClass:[NSMutableDictionary class]])
        dict = [dict mutableCopy];

    // Change remote ID field to local ID field
    id remoteIdValue = [dict objectForKey:[[self class] remoteIdField]];
    if (remoteIdValue != nil) {
        [(NSMutableDictionary*)dict removeObjectForKey:[[self class] remoteIdField]];
        [(NSMutableDictionary*)dict setObject:remoteIdValue forKey:[[self class] localIdField]];
    }

    // Loop through and apply fields in dictionary (if they exist on the object)
    for (NSString* field in [dict allKeys]) {
        NSPropertyDescription *propertyDescription = [[self class] propertyDescriptionForField:field inModel:[self class]];
        //NSLog(@"Property description for %@.%@ is %@", [self class], field, propertyDescription);
        
        if (propertyDescription != nil) {
            id value = [dict objectForKey:field];
            
            // If property is a relationship, do some cascading object creation/updation (occurs regardless of shouldUpdateRoot)
            if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
                Class relationshipClass = NSClassFromString([[(NSRelationshipDescription*)propertyDescription destinationEntity] managedObjectClassName]);
                NSRelationshipDescription* inverseRelationship = [(NSRelationshipDescription*)propertyDescription inverseRelationship];
                
                // Create/update relationship items and assign this object to their inverse relationship (to link them)
                if ([value isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in value)
                        [relationshipClass createOrUpdateWithDictionary:dict andRelationship:inverseRelationship toObject:self];
                }
                else if ([value isKindOfClass:[NSDictionary class]])
                    [relationshipClass createOrUpdateWithDictionary:value andRelationship:inverseRelationship toObject:self];
            }
            
            // If it's an attribute, just assign the value to the object (unless the object is up-to-date)
            else if ([propertyDescription isKindOfClass:[NSAttributeDescription class]] && shouldUpdateRoot) {                
                NSLog(@"Setting property: %@ %@", field, value);
                // Check if value is NSNull, which should be set as nil on fields (since NSNull is just used as a collection placeholder)
                if ([value isEqual:[NSNull null]])
                    [self setValue:nil forKey:field];

                else {
                    // Perform additional processing on value based on attribute type
                    switch ([(NSAttributeDescription*)propertyDescription attributeType]) {
                        case NSDateAttributeType:
                            value = [[[self class] dateParserForField:field] dateFromString:value];
                            break;
                    }
                    [self setValue:value forKey:field];
                }
            }
        }
    }
}



#pragma mark -
#pragma mark Read

+ (CoreResult*) find:(NSString*)resourceId {
    return [self find:resourceId andNotify:nil withSelector:nil];
}

+ (CoreResult*) find:(NSString*)resourceId andNotify:(id)del withSelector:(SEL)selector {
    id obj = [self findLocal:resourceId];
    if (obj != nil)
        return [[CoreResult alloc] initWithResource:obj];
    [self findRemote:resourceId andNotify:del withSelector:selector];
    return nil;
}

+ (CoreResult*) findAll:(id)parameters {
    return nil;
}

+ (CoreResult*) findAll:(NSString*)resourceId andNotify:(id)del withSelector:(SEL)selector {
    return nil;
}

+ (CoreResult*) findLocal:(NSString*)resourceId {
    return nil;
}

+ (CoreResult*) findAllLocal:(id)parameters {
    NSError* error = nil;
    NSFetchRequest* fetch = [self fetchRequestWithSort:nil andPredicate:[self predicateWithParameters:parameters]];
    NSArray* resources = [[self managedObjectContext] executeFetchRequest:fetch error:&error];

    CoreResult* result = [[CoreResult alloc] initWithResources:resources];
    if (error != nil)
        result.error = error;
    return result;
}

+ (void) findRemote:(NSString*)resourceId {
    [self findRemote:resourceId andNotify:nil withSelector:nil];
}

+ (void) findRemote:(NSString *)resourceId andNotify:(id)del withSelector:(SEL)selector {
    [self findAllRemote:[NSString stringWithFormat:@"%@=%@", [self remoteIdField], resourceId] andNotify:del withSelector:selector];
}

+ (void) findAllRemote:(id)parameters {
    [self findAllRemote:parameters andNotify:nil withSelector:nil];
}

+ (void) findAllRemote:(id)parameters andNotify:(id)del withSelector:(SEL)selector {
    CoreRequest *request = [[CoreRequest alloc] initWithURL:
        [CoreUtils URLWithSite:[self remoteCollectionURLForAction:Read] andFormat:@"json" andParameters:parameters]];
    request.delegate = self;
    request.didFinishSelector = @selector(findRemoteDidFinish:);
    request.didFailSelector = @selector(findRemoteDidFail:);
    request.coreDelegate = del;
    request.coreSelector = selector;

    // If we're using bundle requests, just attempt to find the data within the project
    if ([self useBundleRequests]) {
        request.bundleDataPath = [self bundleCollectionPathForAction:Read];
        [request executeAsBundleRequest];
    }
    
    // Enqueue as remote HTTP request 
    else
        [[self coreManager] enqueueRequest:request];
}

+ (void) findRemoteDidFinish:(CoreRequest*)request {
    NSArray* resources = [self deserializeFromString:[request responseString]];
    [[self coreManager] save];
    
    // Notify core delegate of request (if any)
    if (request.coreDelegate && request.coreSelector && [request.coreDelegate respondsToSelector:request.coreSelector]) {
        CoreResult* result = [[CoreResult alloc] init];
        result.resources = resources;
        [request.coreDelegate performSelector:request.coreSelector withObject:result];
    }
}

+ (void) findRemoteDidFail:(CoreRequest*)request {
    NSLog(@"[%@#findRemoteDidFail] Find remote request failed.", self);
}



#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest*) fetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self entityDescription]];
    return fetchRequest;
}

+ (NSFetchRequest*) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate {
    NSFetchRequest *fetchRequest = [self fetchRequest];
    [fetchRequest setSortDescriptors:[CoreUtils sortDescriptorsFromString:sorting]];
    [fetchRequest setPredicate:predicate];
    return fetchRequest;
}

+ (NSPredicate*) predicateWithParameters:(id)parameters {
    return nil;
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

