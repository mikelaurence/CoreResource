//
//  CoreModelDestroyTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelDestroyTests : CoreResourceTestCase {}
@end

@implementation CoreModelDestroyTests

#pragma mark -
#pragma mark Results Management

- (void) testDestroyAllLocal { 
    [self loadAllArtists];
    [Artist destroyAllLocal];
    GHAssertEquals([[Artist findAllLocal] resourceCount], 0, nil);
}

@end
