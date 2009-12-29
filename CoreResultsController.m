//
//  CoreResultsController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

@implementation CoreResultsController

@synthesize entityClass;

- (void) fetch {
    [self fetchLocal];
    [self fetchRemote];
}

- (void) fetchLocal {
    NSError *error = nil;
	if (![performFetch:&error]) {
		NSLog(@"[CoreResultsController#fetchLocal] Error on local core data fetch: %@", error);
	}
}

- (void) fetchRemote {
    [entityClass findAllRemote];
}

@end
