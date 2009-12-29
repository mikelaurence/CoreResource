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

#pragma mark -
#pragma mark Read
+ (id) find:(NSString*)id;
+ (id) findAll:(id)options;

+ (id) findLocal:(NSString*)id;
+ (id) findAllLocal:(id)options;

+ (id) findRemote:(NSString*)id;
+ (id) findAllRemote:(id)options;


#pragma mark -
#pragma mark Results Management

+ (NSFetchRequest) fetchRequest;
+ (NSFetchRequest) fetchRequestWithSort:(NSString*)sorting andPredicate:(NSPredicate*)predicate;
+ (CoreResultsController*) coreResultsControllerWithSort:(NSString*)sorting andSectionKey:(NSString*)sectionKey;
+ (CoreResultsController*) coreResultsControllerWithRequest:(NSFetchRequest*)fetchRequest andSectionKey:(NSString*)sectionKey;

@end

