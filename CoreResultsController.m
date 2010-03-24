//
//  CoreResultsController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "CoreResultsController.h"
#import "CoreUtils.h"
#import "NSString+InflectionSupport.h"


@implementation CoreResultsController

@synthesize entityClass;

- (void) fetch {
    [self fetch:nil];
}

- (void) fetchWithSort:(id)sort {
    [self fetch:nil withSort:sort];
}

- (void) fetch:(id)parameters {
    id sort = [CoreUtils sortDescriptorsFromParameters:parameters];
    [self fetch:parameters withSort:sort];
}


- (void) fetch:(id)parameters withSort:(id)sort {

    self.fetchRequest.predicate = [CoreUtils predicateFromObject:parameters];
    [self.fetchRequest setSortDescriptors:[CoreUtils sortDescriptorsFromParameters:sort]];

    NSError *error = nil;
	if (![self performFetch:&error]) {
		NSLog(@"[CoreResultsController#fetchLocal] Error on local core data fetch: %@", error);
	}
}



#pragma mark -
#pragma mark Convenience fetch methods

- (void) fetchForRelatedResource:(CoreResource*)resource withSort:(id)sort {
    [self fetchForRelatedResource:resource withParameters:nil andSort:sort];
}

- (void) fetchForRelatedResource:(CoreResource*)resource withParameters:(id)parameters andSort:(id)sort {
    [self fetchForResource:resource 
        inRelationship:[NSStringFromClass([resource class]) decapitalize]
        withParameters:parameters
        andSort:sort];
}

- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withSort:(id)sort {
    [self fetchForResource:resource inRelationship:relationshipName withParameters:nil andSort:sort];
}

- (void) fetchForResource:(CoreResource*)resource inRelationship:(NSString*)relationshipName withParameters:(id)parameters andSort:(id)sort {

    // Get relationship to related resource
    NSRelationshipDescription *relationship = [[entityClass performSelector:@selector(relationshipsByName)] objectForKey:relationshipName];

    // Generate relationship predicate
    NSPredicate *relationshipPredicate = [relationship isToMany] ?
        [NSPredicate predicateWithFormat:@"%@ in %K", resource, relationshipName] :
        [NSPredicate predicateWithFormat:@"%K = %@", relationshipName, resource];

    // Compound relationship predicate with parameters predicate if parameters are not nil; otherwise, just keep using relationship predicate
    NSPredicate *fetchPredicate = parameters != nil ? 
        [NSCompoundPredicate andPredicateWithSubpredicates:
            [NSArray arrayWithObjects:relationshipPredicate, [CoreUtils predicateFromObject:parameters], nil]] :
        relationshipPredicate;

    // Perform fetch using parent to generate predicate
    [self fetch:fetchPredicate withSort:[CoreUtils sortDescriptorsFromString:sort]];
}



#pragma mark -
#pragma mark Lifecycle end

- (void) dealloc {
    [super dealloc];
}

@end

#endif