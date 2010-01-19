//
//  CoreModelConfigurationTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelConfigurationTests : CoreResourceTestCase {}
@end

@implementation CoreModelConfigurationTests

#pragma mark -
#pragma mark Tests - Configuration

- (void) testPropertyDescriptionForField {
    NSDictionary* props = [[Artist entityDescription] propertiesByName];
    GHAssertEquals([Artist propertyDescriptionForField:@"name"], [props objectForKey:@"name"], nil);
    GHAssertEquals([Artist propertyDescriptionForField:@"summary"], [props objectForKey:@"summary"], nil);
}

@end
