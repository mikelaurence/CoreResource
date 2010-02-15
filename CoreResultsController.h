//
//  CoreResultsController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "CoreRequest.h"

@class CoreModel;

@interface CoreResultsController : NSFetchedResultsController {
    Class entityClass;
}

@property (nonatomic) Class entityClass;

- (void) fetch;
- (void) fetch:(id)parameters;

#pragma mark -
#pragma mark Convenience fetch methods
- (void) fetchForRelatedResource:(CoreModel*)resource withSort:(NSString*)sort;
- (void) fetchForRelatedResource:(CoreModel*)resource withParameters:(id)parameters andSort:(NSString*)sort;
- (void) fetchForResource:(CoreModel*)resource inRelationship:(NSString*)relationshipName withSort:(NSString*)sort;
- (void) fetchForResource:(CoreModel*)resource inRelationship:(NSString*)relationshipName withParameters:(id)parameters andSort:(NSString*)sort;

@end

