//
//  CoreResourceTestCase.h
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "GHUnit.h"
#import "Artist.h"
#import "CoreUtils.h"
#import "CoreResult.h"

@interface CoreResourceTestCase : GHAsyncTestCase {
    NSMutableDictionary* delegatesCalled;
}

@property (nonatomic, retain) NSMutableDictionary* delegatesCalled;

- (NSString*) artistDataJSON:(NSString*)file;
- (NSDictionary*) artistData:(int)index;
- (void) loadAllArtists;
- (void) loadArtist:(int)index;
- (NSArray*) allLocalArtists;
- (void) validateFirstArtist:(Artist*)artist;
- (void) validateSecondArtist:(Artist*)artist;

- (void) performRequestsAsynchronously;

@end