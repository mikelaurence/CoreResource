//
//  CoreResultsController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "CoreRequest.h"

@class CoreResource;

@interface CoreResultsController : NSFetchedResultsController {
    Class entityClass;
}

@property (nonatomic) Class entityClass;

- (void) fetch;
- (void) fetch:(id)parameters;

#pragma mark -
#pragma mark Convenience fetch methods
- (void) fetchForRelatedResource:(CoreResource*)resource withSort:(NSString*)sort;
- (void) fetchForRelatedResource:(CoreResource*)resource withParameters:(id)parameters andSort:(NSString*)sort;
- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withSort:(NSString*)sort;
- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withParameters:(id)parameters andSort:(NSString*)sort;

@end

