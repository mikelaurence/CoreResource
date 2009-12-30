//
//  CoreModel.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "ASIHTTPRequest.h"
#include "CoreResultsController.h"

@interface CoreModel : NSManagedObject {
    ASIHTTPRequest* request;
}


#pragma mark -
#pragma mark Create

+ (id) create: (id)parameters;
+ (id) createOrUpdateFromDictionary:(NSDictionary*)dict;

#pragma mark -
#pragma mark Read
+ (id) find:(NSString*)id;
+ (id) findAll:(id)parameters;

+ (id) findLocal:(NSString*)id;
+ (id) findAllLocal:(id)parameters;

+ (id) findRemote:(NSString*)id;
+ (id) findAllRemote:(id)parameters;

+ (void) findRemoteDidFinish:(ASIHTTPRequest*)request;
+ (void) findRemoteDidFail:(ASIHTTPRequest*)request;

#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest) fetchRequest;
+ (NSFetchRequest) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate;
+ (CoreResultsController*) coreResultsControllerWithSort:(NSString*)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;

@end

