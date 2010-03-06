//
//  CoreResource.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "CoreManager.h"
#import "CoreResultsController.h"
#import "CoreResult.h"

typedef enum _Action {
    Create = 0,
    Read = 1,
    Update = 2,
    Destroy = 3
} Action;

@interface CoreResource : NSManagedObject {
    ASIHTTPRequest* request;
}

#pragma mark -
#pragma mark Configuration

+ (CoreManager*) coreManager;

// Per-class determination of whether or not to get data from within the bundle (instead of performing remote HTTP requests)
// Most often used for testing.
+ (BOOL) useBundleRequests;

+ (NSString*) remoteSiteURL;
+ (NSString*) remoteCollectionName;
+ (NSString*) remoteURLForCollectionAction:(Action)action;
+ (NSString*) remoteURLForResource:(id)resourceId action:(Action)action;
- (NSString*) remoteURLForAction:(Action)action;
+ (NSString*) bundlePathForCollectionAction:(Action)action;
+ (NSString*) bundlePathForResource:(id)resourceId action:(Action)action;
- (NSString*) bundlePathForAction:(Action)action;

+ (void) configureRequest:(CoreRequest*)request forAction:(NSString*)action;


#pragma mark -
#pragma mark Serialization

+ (NSString*) localNameForRemoteField:(NSString*)name;
+ (NSString*) remoteNameForLocalField:(NSString*)name;
+ (NSString*) localIdField;
- (id) localId;
+ (NSString*) remoteIdField;
+ (NSString*) createdAtField;
+ (NSString*) updatedAtField;
+ (NSDateFormatter*) dateParser;
+ (NSDateFormatter*) dateParserForField:(NSString*)field;
+ (NSArray*) deserializeFromString:(NSString*)serializedString;
+ (NSArray*) dataCollectionFromDeserializedCollection:(NSMutableArray*)deserializedCollection;


#pragma mark -
#pragma mark Core Data

+ (NSManagedObjectContext*) managedObjectContext;
+ (NSManagedObjectModel*) managedObjectModel;
+ (NSString*) entityName;
+ (NSEntityDescription*) entityDescription;
+ (NSDictionary*) relationshipsByName;
+ (BOOL) hasRelationships;
+ (NSDictionary*) propertiesByName;
+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field inModel:(Class)modelClass;
+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field;


#pragma mark -
#pragma mark Create

+ (id) create:(id)parameters;
+ (id) createWithDictionary:(NSDictionary*)dict;
+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict;
+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict andRelationship:(NSRelationshipDescription*)relationship toObject:(CoreResource*)relatedObject;
- (void) updateWithDictionary:(NSDictionary*)dict;
- (BOOL) shouldUpdateWithDictionary:(NSDictionary*)dict;

- (void) didCreate;


#pragma mark -
#pragma mark Read

+ (CoreResult*) find:(id)recordId;
+ (CoreResult*) find:(id)recordId andNotify:(id)del withSelector:(SEL)selector;
+ (CoreResult*) findAll;
+ (CoreResult*) findAll:(id)parameters;
+ (CoreResult*) findAll:(id)parameters andNotify:(id)del withSelector:(SEL)selector;

+ (CoreResult*) findLocal:(id)recordId;
+ (CoreResult*) findAllLocal;
+ (CoreResult*) findAllLocal:(id)parameters;

+ (void) findRemote:(id)recordId;
+ (void) findRemote:(id)recordId andNotify:(id)del withSelector:(SEL)selector;
+ (void) findAllRemote;
+ (void) findAllRemote:(id)parameters;
+ (void) findAllRemote:(id)parameters andNotify:(id)del withSelector:(SEL)selector;

+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request;
+ (void) findRemoteDidFail:(ASIHTTPRequest*)request;



#pragma mark -
#pragma mark Delete

+ (void) destroyAllLocal;
- (void) destroyLocal;



#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest*) fetchRequest;
+ (NSFetchRequest*) fetchRequest:(id)parameters;
+ (NSFetchRequest*) fetchRequestWithDefaultSort;
+ (NSFetchRequest*) fetchRequestWithSort:(id)sorting andPredicate:(NSPredicate*)predicate;
+ (NSPredicate*) predicateWithParameters:(id)parameters;
+ (NSPredicate*) variablePredicateWithParameters:(id)parameters;
+ (CoreResultsController*) coreResultsControllerWithSort:(id)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;


@end

