//
//  CoreUtilsTests.m
//  CoreTest
//
//  Created by Mike Laurence on 3/8/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreUtilsTests : CoreResourceTestCase {}
@end

@implementation CoreUtilsTests

- (void) testDictionaryMacro {
    NSDictionary* d1 = [NSDictionary dictionaryWithObjectsAndKeys:@"valueOne", @"keyOne", @"valueTwo", @"keyTwo", nil];
    NSDictionary* d2 = $D(@"valueOne", @"keyOne", @"valueTwo", @"keyTwo");
    GHAssertEquals([d1 count], [d2 count], nil);
    GHAssertEqualStrings([d1 objectForKey:@"keyOne"], [d2 objectForKey:@"keyOne"], nil);
    GHAssertEqualStrings([d1 objectForKey:@"keyTwo"], [d2 objectForKey:@"keyTwo"], nil);
}

- (void) testArrayMacro {
    NSArray* a1 = [NSArray arrayWithObjects:@"valueOne", @"valueTwo", nil];
    NSArray* a2 = $A(@"valueOne", @"valueTwo");
    GHAssertEquals([a1 count], [a2 count], nil);
    GHAssertEqualStrings([a1 objectAtIndex:0], [a2 objectAtIndex:0], nil);
    GHAssertEqualStrings([a1 objectAtIndex:1], [a2 objectAtIndex:1], nil);
}

- (void) testStringMacro {
    NSString* s1 = [NSString stringWithFormat:@"Test %@ String %@", @"One", [NSNumber numberWithInt:1]];
    NSString* s2 = $S(@"Test %@ String %@", @"One", [NSNumber numberWithInt:1]);
    GHAssertEqualStrings(s1, s2, nil);
}

- (void) testIntMacro {
    GHAssertEquals(42, [$I(42) intValue], nil);
}

- (void) testFloatMacro {
    GHAssertEquals([[NSNumber numberWithFloat:42.42] floatValue], [$F(42.42) floatValue], nil);
}

- (void) testBoolMacro {
    GHAssertEquals(YES, [$B(YES) boolValue], nil);
}



@end
