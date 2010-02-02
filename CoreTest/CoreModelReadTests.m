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

- (void) setUp {
    [CoreManager main].bundleRequestDelay = 0;
    [super setUp];
}

#pragma mark -
#pragma mark Read
/*
- (void) testFindWithoutLocalHit {
    GHAssertNULL([Artist find:[NSNumber numberWithInt:0]], @"Find should not immediately return an object if the object doesn't yet exist");
    
    // Verify existance of artist after find call
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
}

- (void) testFindWithLocalHit {
    [self loadArtist:0];
    CoreResult* result = [Artist find:[NSNumber numberWithInt:0]];
    GHAssertNotNULL([result resources], nil);
    GHAssertEquals([[result resources] count], 1, nil);
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
}

/*

- (void) testFindAndNotify {
    [self performRequestsAsynchronously];
    [self prepare];
    [Artist find:[NSNumber numberWithInt:0] andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 1, nil);
    [self validateFirstArtist:[[result resources] lastObject]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAndNotify:)];
}

- (void) testFindAllWithoutLocalHits { 
    GHAssertNULL([[Artist findAll] resources], @"Find all should not immediately any objects if the objects don't yet exist");
    
    // Verify existance of artists after find call
    GHAssertEquals([[self allLocalArtists] count], 3, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
}

- (void) testFindAllWithSomeLocalHits { 
    // Pre-fetch two artists so that they're cached locally
    [self loadArtist:0];
    [self loadArtist:2];
    
    CoreResult* result = [Artist findAll];
    GHAssertNotNULL([result resources], nil);
    GHAssertEquals([[result resources] count], 1, nil);
    GHAssertEquals([[self allLocalArtists] count], 3, nil);
    [self validateSecondArtist:(Artist*)[result resource]];
}
 
- (void) testFindAllWithAllLocalHits { 
    // Pre-fetch all artists
    [self loadAllArtists];
    
    CoreResult* result = [Artist findAll];
    GHAssertNotNULL([result resources], nil);
    GHAssertEquals([[result resources] count], 3, nil);
    GHAssertEquals([[self allLocalArtists] count], 3, nil);
}

- (void) testFindAllParameterizedWithoutLocalHits { GHFail(nil); }
- (void) testFindAllParameterizedWithLocalHits { GHFail(nil); }

- (void) testFindAllAndNotify { 
    [self performRequestsAsynchronously];
    [self prepare];
    [Artist findAll:nil andNotify:self withSelector:@selector(completeTestFindAllAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAllAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 3, nil);
    [self validateFirstArtist:[[result resources] objectAtIndex:0]];
    [self validateSecondArtist:[[result resources] objectAtIndex:1]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAllAndNotify:)];
}
*/
- (void) testFindLocal {
    [self loadArtist:1];

    CoreResult* result = [Artist findLocal:[NSNumber numberWithInt:1]];
    GHAssertEquals([result resourceCount], 1, nil);
    [self validateSecondArtist:(Artist*)[result resource]];
}

- (void) testFindAllLocal {
    [self loadAllArtists];
    
    CoreResult* result = [Artist findAllLocal];
    GHAssertEquals([result resourceCount], 3, nil);
    // Sort results by ID manually so we can validate
    NSArray* sortedResources = [[result resources] sortedArrayUsingDescriptors:
        [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"resourceId" ascending:YES]]];
    [self validateFirstArtist:(Artist*)[sortedResources objectAtIndex:0]];
    [self validateSecondArtist:(Artist*)[sortedResources objectAtIndex:1]];
}

- (void) testFindRemote {
    [Artist findRemote:[NSNumber numberWithInt:1]];
    int count = [[self allLocalArtists] count];
    GHAssertEquals(count, 1, nil);
    [self validateSecondArtist:(Artist*)[[self allLocalArtists] lastObject]];
}
/*
- (void) testFindRemoteAndNotify { 
    [self performRequestsAsynchronously];
    [self prepare];
    [Artist findRemote:[NSNumber numberWithInt:0] andNotify:self withSelector:@selector(completeTestFindRemoteAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindRemoteAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 1, nil);
    [self validateFirstArtist:(Artist*)[result resource]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindRemoteAndNotify:)];
}

- (void) testFindAllRemote {  
    [Artist findAllRemote];

    GHAssertEquals([[self allLocalArtists] count], 3, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
}

- (void) testFindAllRemoteAndNotify {
    [self performRequestsAsynchronously];
    [self prepare];
    [Artist findAllRemote:nil andNotify:self withSelector:@selector(completeTestFindAllRemoteAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAllRemoteAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 3, nil);
    [self validateFirstArtist:(Artist*)[result resource]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAllRemoteAndNotify:)];
}
*/

@end
