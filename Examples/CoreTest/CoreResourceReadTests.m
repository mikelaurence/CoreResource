//
//  CoreResourceReadTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreResourceReadTests : CoreResourceTestCase {}
@end

@implementation CoreResourceReadTests

- (void) setUp {
    coreManager.bundleRequestDelay = 0;
    [super setUp];
}

- (BOOL)shouldRunOnMainThread { return YES; }

#pragma mark -
#pragma mark Read

- (void) testFindWithoutLocalHit {
    GHAssertFalse([[Artist find:[NSNumber numberWithInt:0]] hasAnyResources], @"Find should not immediately return an object if the object doesn't yet exist");
    [NSThread sleepForTimeInterval:0.1];
    
    // Verify existance of artist after find call
    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 1, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
}

- (void) testFindWithLocalHit {
    [self loadArtist:0];
    CoreResult* result = [Artist find:[NSNumber numberWithInt:0]];
    GHAssertEquals((NSInteger) [result resourceCount], 1, nil);
    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 1, nil);
}

- (void) testFindAndNotify {
    [self performRequestsAsynchronously];
    [self prepare:@selector(completeTestFindAndNotify:)];
    [Artist find:[NSNumber numberWithInt:0] andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    GHAssertEquals((NSInteger) [result resourceCount], 1, nil);
    [self validateFirstArtist:[[result resources] lastObject]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAndNotify:)];
}

- (void) testFindAllWithoutLocalHits { 
    GHAssertFalse([[Artist findAll] hasAnyResources], @"Find all should not immediately any objects if the objects don't yet exist");
    [NSThread sleepForTimeInterval:0.1];
    
    // Verify existance of artists after find call
    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 3, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
}

- (void) testFindAllWithSomeLocalHits { 
    // Pre-fetch two artists so that they're cached locally
    [self loadArtist:0];
    [self loadArtist:2];
    
    CoreResult* result = [Artist findAll];
    GHAssertEquals((NSInteger) [result resourceCount], 2, nil);
    
    [NSThread sleepForTimeInterval:0.1];
    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 3, nil);
}
 
- (void) testFindAllWithAllLocalHits { 
    // Pre-fetch all artists
    [self loadAllArtists];

    CoreResult* result = [Artist findAll];
    GHAssertEquals((NSInteger) [result resourceCount], 3, nil);
    
    [NSThread sleepForTimeInterval:0.1];
    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 3, nil);
}

/*
- (void) testFindAllParameterizedWithoutLocalHits { GHFail(nil); }
- (void) testFindAllParameterizedWithLocalHits { GHFail(nil); }
*/

- (void) testFindAllAndNotify {
    [self performRequestsAsynchronously];
    [self prepare:@selector(completeTestFindAllAndNotify:)];
    [Artist findAll:nil andNotify:self withSelector:@selector(completeTestFindAllAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAllAndNotify:(CoreResult*)result {
    GHAssertEquals([result resourceCount], 3, nil);
    [self validateFirstArtist:[[result resources] objectAtIndex:0]];
    [self validateSecondArtist:[[result resources] objectAtIndex:1]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAllAndNotify:)];
}

- (void) testFindLocal {
    [self loadArtist:1];

    CoreResult* result = [Artist findLocal:[NSNumber numberWithInt:1]];
    GHAssertEquals([result resourceCount], 1, nil);
    [self validateSecondArtist:(Artist*)[result resource]];
}

- (void) testFindAllLocal {
    [self loadAllArtists];
    CoreResult* result = [Artist findAllLocal];
    GHAssertEquals((NSInteger) [result resourceCount], 3, nil);
    // Sort results by ID manually so we can validate
    NSArray* sortedResources = [[result resources] sortedArrayUsingDescriptors:
        [CoreUtils sortDescriptorsFromString:@"resourceId ASC"]];
    [self validateFirstArtist:(Artist*)[sortedResources objectAtIndex:0]];
    [self validateSecondArtist:(Artist*)[sortedResources objectAtIndex:1]];
}


- (void) testFindRemote {
    [Artist findRemote:[NSNumber numberWithInt:1]];
    [NSThread sleepForTimeInterval:0.1];

    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 1, nil);
    [self validateSecondArtist:(Artist*)[[self allLocalArtists] lastObject]];
}

- (void) testFindRemoteAndNotify { 
    [self performRequestsAsynchronously];
    [self prepare:@selector(completeTestFindRemoteAndNotify:)];
    [Artist findRemote:[NSNumber numberWithInt:0] andNotify:self withSelector:@selector(completeTestFindRemoteAndNotify:)];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindRemoteAndNotify:(CoreResult*)result {
    GHAssertEquals((NSInteger) [result resourceCount], 1, nil);
    [self validateFirstArtist:(Artist*)[result resource]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindRemoteAndNotify:)];
}

- (void) testFindAllRemote {
    [Artist findAllRemote];
    [NSThread sleepForTimeInterval:0.1];

    GHAssertEquals((NSInteger) [[self allLocalArtists] count], 3, nil);
    [self validateFirstArtist:[[self allLocalArtists] objectAtIndex:0]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
}

- (void) testFindAllRemoteAndNotify {
    [self performRequestsAsynchronously];
    [self prepare:@selector(completeTestFindAllRemoteAndNotify:)];
    @try {
    [Artist findAllRemote:nil andNotify:self withSelector:@selector(completeTestFindAllRemoteAndNotify:)];
    }
    @catch (NSException *exception) {
                            NSLog(@"EXCEPTION: Caught %@: %@", [exception name], [exception reason]);
                        }
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:1.0];
}

- (void) completeTestFindAllRemoteAndNotify:(CoreResult*)result {
    GHAssertEquals((NSInteger) [result resourceCount], 3, nil);
    [self validateFirstArtist:(Artist*)[result resource]];
    [self validateSecondArtist:[[self allLocalArtists] objectAtIndex:1]];
    [self notify:kGHUnitWaitStatusSuccess forSelector:@selector(completeTestFindAllRemoteAndNotify:)];
}

@end
