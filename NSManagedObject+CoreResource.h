//
//  NSManagedObject+CoreResource.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "ASIHTTPRequest.h"

@interface NSManagedObject (CoreResource) {
    ASIHTTPRequest* request;
}

+ (id) find:(NSString*)id;
+ (id) find:(NSString*)id withConditions:(NSDictionary*)conditions;
+ (id) all:(NSString*)id;
+ (id) all:(NSString*)id withConditions:(NSDictionary*)conditions;

@end

