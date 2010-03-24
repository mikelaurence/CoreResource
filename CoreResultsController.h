//
//  CoreResultsController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "CoreRequest.h"

@class CoreResource;

@interface CoreResultsController : NSFetchedResultsController {
    Class entityClass;
}

@property (nonatomic) Class entityClass;

- (void) fetch;
- (void) fetchWithSort:(id)sort;
- (void) fetch:(id)parameters;
- (void) fetch:(id)parameters withSort:(id)sort;

#pragma mark -
#pragma mark Convenience fetch methods
- (void) fetchForRelatedResource:(CoreResource*)resource withSort:(id)sort;
- (void) fetchForRelatedResource:(CoreResource*)resource withParameters:(id)parameters andSort:(id)sort;
- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withSort:(id)sort;
- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withParameters:(id)parameters andSort:(id)sort;

@end

#endif