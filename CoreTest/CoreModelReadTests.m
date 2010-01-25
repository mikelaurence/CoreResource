//
//  CoreModelReadTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelReadTests : CoreResourceTestCase {}
@end

@implementation CoreModelReadTests

#pragma mark -
#pragma mark Read


- (void) testFindWithoutLocalHit {
    GHAssertNULL([Artist find:@"1"], @"Find should not immediately return an object if the object doesn't yet exist");
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
    Artist* artist = [[self allLocalArtists] objectAtIndex:0];
    [self validateFirstArtist:artist];
}

- (void) testFindWithLocalHit {
    CoreResult* result = [Artist find:@"1"];
    GHAssertNotNULL(result, nil);
    GHAssertEquals([[result resources] count], 1, nil);
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
}

- (void) testFindAndNotify {
    [Artist find:@"1" andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 1, nil);
    GHFail(nil);
}

- (void) testFindAllWithoutLocalHits { GHFail(nil); }
- (void) testFindAllWithLocalHits { GHFail(nil); }
- (void) testFindAllParameterizedWithoutLocalHits { GHFail(nil); }
- (void) testFindAllParameterizedWithLocalHits { GHFail(nil); }
- (void) testFindAllAndNotify { GHFail(nil); }
- (void) testFindLocal { GHFail(nil); }
- (void) testFindAllLocal { GHFail(nil); }
- (void) testFindRemote { GHFail(nil); }
- (void) testFindRemoteAndNotify { GHFail(nil); }
- (void) testFindAllRemote { GHFail(nil); }
- (void) testFindAllRemoteAndNotify { GHFail(nil); }


- (void) testZ {
    GHAssertNotNil([delegatesCalled objectForKey:@"completeTestFindAndNotify"], @"completeTestFindAndNotify not called");
}

@end
