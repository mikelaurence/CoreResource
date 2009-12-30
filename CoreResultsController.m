//
//  CoreResultsController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "CoreResultsController.h"

@implementation CoreResultsController

@synthesize entityClass;

- (void) fetch:(id)parameters {
    [self fetchLocal:parameters];
    [self fetchRemote:parameters];
}

- (void) fetchLocal:(id)parameters {
    NSError *error = nil;
	if (![self performFetch:&error]) {
		NSLog(@"[CoreResultsController#fetchLocal] Error on local core data fetch: %@", error);
	}
}

- (void) fetchRemote:(id)parameters {
    [entityClass performSelector:@selector(findAllRemote:) withObject:parameters];
}

@end
