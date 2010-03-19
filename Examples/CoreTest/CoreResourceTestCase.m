//
//  CoreResourceTestCase.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@implementation CoreResourceTestCase

@synthesize delegatesCalled;

static int dbInc = 1;

#pragma mark -
#pragma mark Convenience methods

- (NSString*) artistDataJSON:(NSString*)file {
    NSError* parseError;
    return [NSString stringWithContentsOfFile:
        [[NSBundle mainBundle] pathForResource:file ofType:@"json"] 
        encoding:NSUTF8StringEncoding error:&parseError];
}

- (NSDictionary*) artistData:(int)index {
    return [[self artistDataJSON:[NSString stringWithFormat:@"artists.%@", [NSNumber numberWithInt:index]]] JSONValue];
}

- (void) loadAllArtists {
    [self loadArtist:0];
    [self loadArtist:1];
    [self loadArtist:2];
}

- (Artist*) loadArtist:(int)index {
    return [self loadArtist:index inContext:[coreManager managedObjectContext]];
}

- (Artist*) loadArtist:(int)index andSave:(BOOL)shouldSave {
    return [self loadArtist:index andSave:shouldSave inContext:[coreManager managedObjectContext]];
}

- (Artist*) loadArtist:(int)index inContext:(NSManagedObjectContext*)context {
    return [self loadArtist:index andSave:YES inContext:context];
}

- (Artist*) loadArtist:(int)index andSave:(BOOL)shouldSave inContext:(NSManagedObjectContext*)context {
    Artist* artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
    NSDictionary* dict = [self artistData:index];
    artist.resourceId = [dict objectForKey:@"id"];
    artist.name = [dict objectForKey:@"name"];
    artist.summary = [dict objectForKey:@"summary"];
    artist.detail = [dict objectForKey:@"detail"];
    artist.updatedAt = [[coreManager defaultDateParser] dateFromString:[dict objectForKey:@"updatedAt"]];
    
    NSDictionary* songsArray = [dict objectForKey:@"songs"];
    NSMutableSet* songs = [NSMutableSet set];
    if (songsArray) {
        for (NSDictionary* dict in songsArray) {
            Song* song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
            song.resourceId = [dict objectForKey:@"id"];
            song.name = [dict objectForKey:@"name"];
            [songs addObject:song];
        }
        artist.songs = songs;
    }
    
    if (shouldSave) {
        NSError *error = nil;
        [context save:&error];
    }
    
    return artist;
}

- (NSArray*) allLocalArtists {
    NSError* error = nil;
    NSArray* artists = [[Artist managedObjectContext] executeFetchRequest:[Artist fetchRequestWithSort:@"resourceId ASC" andPredicate:nil] error:&error];
    GHAssertNULL(error, @"There should be no errors in the allLocalArtists convenience method");
    NSLog(@"%i local artists", [artists count]);
    return artists != nil ? artists : [NSArray array];
}

- (void) validateFirstArtist:(Artist*)artist {
    GHAssertEqualStrings(artist.name, @"Peter Gabriel", nil);
    GHAssertEqualStrings(artist.summary, @"Peter Brian Gabriel is an English musician and songwriter.", nil);
    GHAssertEquals([artist.resourceId intValue], 0, nil);
}

- (void) validateSecondArtist:(Artist*)artist {
    GHAssertEqualStrings(artist.name, @"Spoon", nil);
    GHAssertEqualStrings(artist.summary, @"Spoon is an American indie rock band from Austin, Texas.", nil);
    GHAssertEquals([artist.resourceId intValue], 1, nil);
    GHAssertEquals((NSInteger) [artist.songs count], 2, nil);
    GHAssertEqualStrings(((Song*)[[artist sortedSongs] objectAtIndex:0]).name, @"Don't Make Me a Target", nil);
    GHAssertEqualStrings(((Song*)[[artist sortedSongs] objectAtIndex:1]).name, @"You Got Yr. Cherry Bomb", nil);
}



#pragma mark -
#pragma mark GHUnit Configuration

- (void) setUp {
    NSString *dbName = $S(@"db-%i-%i.sqlite", [NSDate timeIntervalSinceReferenceDate], dbInc++);
    NSLog(@"\n\nCreating core manager with DB named '%@'\n\n", dbName);
    coreManager = [[CoreManager alloc] initWithOptions:$D(dbName, @"dbName")];
    coreManager.logLevel = 2;
    coreManager.useBundleRequests = YES;
    coreManager.bundleRequestDelay = 0.01;
    [CoreManager setMain:coreManager];
}

- (void) tearDown {
    [coreManager release];
    coreManager = nil;
}


@end