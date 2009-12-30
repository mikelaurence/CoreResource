//
//  CoreModel.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "ASIHTTPRequest.h"
#include "CoreManager.h"
#include "CoreResultsController.h"

@interface CoreModel : NSManagedObject {
    ASIHTTPRequest* request;
}

#pragma mark -
#pragma mark Configuration

+ (CoreManager*) coreManager;
+ (NSString*) remoteSiteURL;



#pragma mark -
#pragma mark Serialization

+ (NSString*) localIdField;
+ (NSString*) remoteIdField;
+ (NSDateFormatter*) dateParser;
+ (NSDateFormatter*) dateParserForField:(NSString*)field;
+ (NSArray*) deserializeFromString:(NSString*)serializedString;
+ (id) dataCollectionFromDeserializedCollection:(id)deserializedCollection;



#pragma mark -
#pragma mark Create

+ (id) create: (id)parameters;
+ (id) createOrUpdateWithDictionary:(NSDictionary*)dict;
- (void) updateWithDictionary:(NSDictionary*)dict;
- (BOOL) shouldUpdateWithDictionary:(NSDictionary*)dict;


#pragma mark -
#pragma mark Read
+ (id) find:(NSString*)recordId;
+ (id) findAll:(id)parameters;

+ (id) findLocal:(NSString*)recordId;
+ (id) findAllLocal:(id)parameters;

+ (void) findRemote:(NSString*)recordId;
+ (void) findAllRemote:(id)parameters;
+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request;
+ (void) findRemoteDidFail:(ASIHTTPRequest*)request;



#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest*) fetchRequest;
+ (NSFetchRequest*) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate;
+ (CoreResultsController*) coreResultsControllerWithSort:(NSString*)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;

@end

