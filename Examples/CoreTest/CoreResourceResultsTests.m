//
//  CoreResourceResultsTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreResourceResultsTests : CoreResourceTestCase {}
@end

@implementation CoreResourceResultsTests

#pragma mark -
#pragma mark Results Management
/*
- (void) testFetchRequest { GHFail(nil); }
- (void) testFetchRequestWithSortAndPredicate { GHFail(nil); }
- (void) testPredicateWithParameters { GHFail(nil); }
- (void) testCoreResultsControllerWithSortAndSection { GHFail(nil); }
- (void) testCoreResultsControllerWithRequestAndSectionKey { GHFail(nil); }
*/

- (void) testFastEnumeration {
    for (Artist* artist in [Artist findAll])
        GHAssertTrue([artist isKindOfClass:[Artist class]], nil);
        
    for (Artist* artist in [Artist find:$I(-1)])
        GHFail(@"No objects should be iterated over in [Artist find:-1]");
}

@end
