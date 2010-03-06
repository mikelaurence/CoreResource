//
//  CoreResourceDestroyTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreResourceDestroyTests : CoreResourceTestCase {}
@end

@implementation CoreResourceDestroyTests

#pragma mark -
#pragma mark Results Management

- (void) testDestroyAllLocal { 
    [self loadAllArtists];
    GHAssertTrue([[Artist findAllLocal] resourceCount] > 0, nil);
    [Artist destroyAllLocal];
    GHAssertEquals([[Artist findAllLocal] resourceCount], 0, nil);
}

@end
