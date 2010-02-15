//
//  CoreResultsController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "CoreResultsController.h"
#import "CoreUtils.h"


@implementation CoreResultsController

@synthesize entityClass;

- (void) fetch {
    [self fetch:nil];
}

- (void) fetch:(id)parameters {

    // If parameter is a predicate, set it on the results controller
    if ([parameters isKindOfClass:[NSPredicate class]])
        self.fetchRequest.predicate = parameters;

    NSError *error = nil;
	if (![self performFetch:&error]) {
		NSLog(@"[CoreResultsController#fetchLocal] Error on local core data fetch: %@", error);
	}
}



#pragma mark -
#pragma mark Convenience fetch methods

- (void) fetchForRelatedResource:(CoreModel*)resource withSort:(NSString*)sort {
    [self fetchForRelatedResource:resource withParameters:nil andSort:sort];
}

- (void) fetchForRelatedResource:(CoreModel*)resource withParameters:(id)parameters andSort:(NSString*)sort {
    [self fetchForResource:resource 
        inRelationship:[NSStringFromClass([resource class]) decapitalize]
        withParameters:parameters
        andSort:sort];
}

- (void) fetchForResource:(CoreModel*)resource inRelationship:(NSString*)relationshipName withSort:(NSString*)sort {
    [self fetchForResource:resource inRelationship:relationshipName withParameters:nil andSort:sort];
}

- (void) fetchForResource:(CoreModel*)resource inRelationship:(NSString*)relationshipName withParameters:(id)parameters andSort:(NSString*)sort {
    // Configure sort
    [self.fetchRequest setSortDescriptors:[CoreUtils sortDescriptorsFromString:sort]];

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
    [self fetch:fetchPredicate];
}





#pragma mark -
#pragma mark Lifecycle end

- (void) dealloc {
    [super dealloc];
}

@end
