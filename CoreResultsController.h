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

@property (nonatomic, retain) Class entityClass;

- (void) fetch;
- (void) fetchLocal;
- (void) fetchRemote;

@end

