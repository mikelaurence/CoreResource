//
//  NSArrayCategoryTests.m
//  CoreTest
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"
#import "NSArray+Core.h"


@interface NSArrayCategoryTests : CoreResourceTestCase {}
@end

@implementation NSArrayCategoryTests

- (void) testSortedArrayByKey {
    NSArray* unsorted = $A($D(@"one", @"name"), $D(@"two", @"name"), $D(@"three", @"name"), $D(@"four", @"name"));
    
    NSArray* ascending = [unsorted sortedArrayUsingKey:@"name" ascending:YES];
    GHAssertEqualStrings([[ascending objectAtIndex:0] objectForKey:@"name"], @"four", nil);
    GHAssertEqualStrings([[ascending objectAtIndex:1] objectForKey:@"name"], @"one", nil);
    GHAssertEqualStrings([[ascending objectAtIndex:2] objectForKey:@"name"], @"three", nil);
    GHAssertEqualStrings([[ascending objectAtIndex:3] objectForKey:@"name"], @"two", nil);
    
    NSArray* descending = [unsorted sortedArrayUsingKey:@"name" ascending:NO];
    GHAssertEqualStrings([[descending objectAtIndex:0] objectForKey:@"name"], @"two", nil);
    GHAssertEqualStrings([[descending objectAtIndex:1] objectForKey:@"name"], @"three", nil);
    GHAssertEqualStrings([[descending objectAtIndex:2] objectForKey:@"name"], @"one", nil);
    GHAssertEqualStrings([[descending objectAtIndex:3] objectForKey:@"name"], @"four", nil);
}

@end
