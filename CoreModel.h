//
//  CoreModel.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "CoreManager.h"
#include "CoreResultsController.h"
#include "CoreResult.h"

typedef enum _Action {
    Create = 0,
    Read = 1,
    Update = 2,
    Destroy = 3
} Action;

@interface CoreModel : NSManagedObject {
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
+ (NSString*) remoteCollectionURLForAction:(Action)action;
- (NSString*) remoteResourceURLForAction:(Action)action;
+ (NSString*) bundleCollectionPathForAction:(Action)action;
- (NSString*) bundleResourcePathForAction:(Action)action;

+ (NSPropertyDescription*) propertyDescriptionForField:(NSString*)field inModel:(Class)modelClass;


#pragma mark -
#pragma mark Serialization

+ (NSString*) localIdField;
+ (NSString*) remoteIdField;
+ (NSDateFormatter*) dateParser;
+ (NSDateFormatter*) dateParserForField:(NSString*)field;
+ (NSArray*) deserializeFromString:(NSString*)serializedString;
+ (NSArray*) dataCollectionFromDeserializedCollection:(NSMutableArray*)deserializedCollection;


#pragma mark -
#pragma mark Core Data

+ (NSString*) entityName;
+ (NSEntityDescription*) entityDescription;
+ (BOOL) hasRelationships;
+ (NSManagedObjectContext*) managedObjectContext;


#pragma mark -
#pragma mark Create

+ (id) create: (id)parameters;
+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict;
+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict andRelationship:(NSRelationshipDescription*)relationship toObject:(CoreModel*)object;
- (void) updateWithDictionary:(NSDictionary*)dict;
- (BOOL) shouldUpdateWithDictionary:(NSDictionary*)dict;


#pragma mark -
#pragma mark Read
+ (CoreResult*) find:(NSString*)recordId;
+ (CoreResult*) find:(NSString*)recordId andNotify:(id)del withSelector:(SEL)selector;
+ (CoreResult*) findAll:(id)parameters;
+ (CoreResult*) findAll:(id)parameters andNotify:(id)del withSelector:(SEL)selector;

+ (CoreResult*) findLocal:(NSString*)recordId;
+ (CoreResult*) findAllLocal:(id)parameters;

+ (void) findRemote:(NSString*)recordId;
+ (void) findRemote:(NSString*)recordId andNotify:(id)del withSelector:(SEL)selector;
+ (void) findAllRemote:(id)parameters;
+ (void) findAllRemote:(id)parameters andNotify:(id)del withSelector:(SEL)selector;

+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request;
+ (void) findRemoteDidFail:(ASIHTTPRequest*)request;



#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest*) fetchRequest;
+ (NSFetchRequest*) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate;
+ (NSPredicate*) predicateWithParameters:(id)parameters;
+ (CoreResultsController*) coreResultsControllerWithSort:(NSString*)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;


@end

