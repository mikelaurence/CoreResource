//
//  CoreResultsController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

@interface CoreResultsController : NSFetchedResultsController {
    Class entityClass;
}

@property (nonatomic) Class entityClass;

- (void) fetch:(id)parameters;
- (void) fetchLocal:(id)parameters;
- (void) fetchRemote:(id)parameters;

@end

