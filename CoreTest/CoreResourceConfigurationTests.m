//
//  CoreResourceConfigurationTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreResourceConfigurationTests : CoreResourceTestCase {}
@end

@implementation CoreResourceConfigurationTests

#pragma mark -
#pragma mark Tests - Configuration

- (void) testPropertyDescriptionForField {
    NSDictionary* props = [[Artist entityDescription] propertiesByName];
    GHAssertNotNil([Artist propertyDescriptionForField:@"name"], nil);
    GHAssertNotNil([Artist propertyDescriptionForField:@"summary"], nil);
    GHAssertEquals([Artist propertyDescriptionForField:@"name"], [props objectForKey:@"name"], nil);
    GHAssertEquals([Artist propertyDescriptionForField:@"summary"], [props objectForKey:@"summary"], nil);
}

@end
