//
//  CoreResultsController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#include "CoreRequest.h"

@interface CoreResultsController : NSFetchedResultsController {
    Class entityClass;
}

@property (nonatomic) Class entityClass;

- (void) fetch;
- (void) fetch:(id)parameters;
- (void) fetchLocal:(id)parameters;
- (void) fetchRemote:(id)parameters;

@end

