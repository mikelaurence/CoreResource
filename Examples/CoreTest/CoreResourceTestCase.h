//
//  CoreResourceTestCase.h
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "GHUnit.h"
#import "Artist.h"
#import "Song.h"
#import "CoreUtils.h"
#import "CoreResult.h"

@interface CoreResourceTestCase : GHAsyncTestCase {
    CoreManager *coreManager;
    NSMutableDictionary* delegatesCalled;
}

@property (nonatomic, retain) NSMutableDictionary* delegatesCalled;

- (NSString*) artistDataJSON:(NSString*)file;
- (NSDictionary*) artistData:(int)index;
- (void) loadAllArtists;
- (Artist*) loadArtist:(int)index;
- (Artist*) loadArtist:(int)index andSave:(BOOL)shouldSave;
- (Artist*) loadArtist:(int)index inContext:(NSManagedObjectContext*)context;
- (Artist*) loadArtist:(int)index andSave:(BOOL)shouldSave inContext:(NSManagedObjectContext*)context;
- (NSArray*) allLocalArtists;
- (void) validateFirstArtist:(Artist*)artist;
- (void) validateSecondArtist:(Artist*)artist;

- (void) performRequestsAsynchronously;

#pragma mark -
#pragma mark Sorting
NSInteger ascendingSort(id obj1, id obj2, void *key);


@end