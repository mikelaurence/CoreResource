//
//  CoreResourceTestCase.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@implementation CoreResourceTestCase

@synthesize delegatesCalled;

#pragma mark -
#pragma mark Convenience methods

- (NSArray*) allLocalArtists {
    NSError* error = nil;
    GHAssertNULL(error, @"There should be no errors in the allLocalArtists convenience method");
    return [[Artist managedObjectContext] executeFetchRequest:[Artist fetchRequest] error:&error];
}

- (void) validateFirstArtist:(Artist*)artist {
    GHAssertEqualStrings(artist.name, @"Peter Gabriel", nil);
    GHAssertEqualStrings(artist.summary, @"Peter Brian Gabriel is an English musician and songwriter.", nil);
    GHAssertEquals([artist.remote_id intValue], 1, nil);
}



#pragma mark -
#pragma mark GHUnit Configuration

- (BOOL)shouldRunOnMainThread { return NO; }

- (void) setUpClass {
    self.delegatesCalled = [NSMutableDictionary dictionary];
}

- (void)tearDown {
    for (Artist* artist in [self allLocalArtists])
        [[artist managedObjectContext] deleteObject:artist];
}


@end