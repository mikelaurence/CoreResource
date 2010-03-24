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

+ (Class) deserializerClassForFormat:(NSString*)format;
//+ (id) resourceCollectionFromJSONCollection:(id)jsonCollection withParent:(id)parent;
//+ (id) resourcePropertiesFromJSONElement:(id)jsonElement withParent:(id)parent;

- (NSString*) toJson;
- (NSString*) toJson:(id)options;
- (NSMutableDictionary*) properties;
- (NSMutableDictionary*) properties:(NSDictionary*)options;
- (NSMutableDictionary*) properties:(NSDictionary*)options withoutObjects:(NSArray*)withouts;


#pragma mark -
#pragma mark Core Data

+ (NSManagedObjectContext*) managedObjectContext;
+ (NSManagedObjectModel*) managedObjectModel;
+ (NSString*) entityName;
+ (NSEntityDescription*) entityDescription;
+ (NSDictionary*) relationshipsByName;
+ (BOOL) hasRelationships;
+ (NSDictionary*) propertiesByName;
+ (NSDictionary*) attributesByName;
+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field inModel:(Class)modelClass;
+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field;


#pragma mark -
#pragma mark Create

+ (id) create:(id)parameters;
+ (id) create:(id)parameters withOptions:(NSDictionary*)options;
+ (id) createOrUpdate:(id)parameters;
+ (id) createOrUpdate:(id)parameters withOptions:(NSDictionary*)options;
- (void) update:(NSDictionary*)dict;
- (void) update:(NSDictionary*)dict withOptions:(NSDictionary*)options;
- (BOOL) shouldUpdateWith:(NSDictionary*)dict;
+ (NSDictionary*) defaultCreateOptions;
+ (NSDictionary*) defaultCreateOrUpdateOptions;
+ (NSDictionary*) defaultUpdateOptions;

- (void) didCreate;


#pragma mark -
#pragma mark Read

+ (CoreResult*) find:(id)resourceId;
+ (CoreResult*) find:(id)resourceId andNotify:(id)del withSelector:(SEL)selector;
+ (CoreResult*) findAll;
+ (CoreResult*) findAll:(id)parameters;
+ (CoreResult*) findAll:(id)parameters andNotify:(id)del withSelector:(SEL)selector;

+ (CoreResult*) findLocal:(id)resourceId;
+ (CoreResult*) findLocal:(id)resourceId inContext:(NSManagedObjectContext*)context;
+ (CoreResult*) findAllLocal;
+ (CoreResult*) findAllLocal:(id)parameters inContext:(NSManagedObjectContext*)context;
+ (CoreResult*) findAllLocal:(id)parameters;
+ (int) countLocal;
+ (int) countLocal:(id)parameters;
+ (int) countLocal:(id)parameters inContext:(NSManagedObjectContext*)context;

+ (void) findRemote:(id)resourceId;
+ (void) findRemote:(id)resourceId andNotify:(id)del withSelector:(SEL)selector;
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

#if TARGET_OS_IPHONE
+ (CoreResultsController*) coreResultsControllerWithSort:(id)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;
#endif

@end
