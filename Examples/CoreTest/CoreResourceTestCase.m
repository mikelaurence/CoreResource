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
    Artist* artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:[[CoreManager main] managedObjectContext]];
    NSDictionary* dict = [self artistData:index];
    artist.resourceId = [dict objectForKey:@"id"];
    artist.name = [dict objectForKey:@"name"];
    artist.summary = [dict objectForKey:@"summary"];
    artist.detail = [dict objectForKey:@"detail"];
    artist.updatedAt = [[[CoreManager main] defaultDateParser] dateFromString:[dict objectForKey:@"updatedAt"]];
    return artist;
}

- (NSArray*) allLocalArtists {
    NSError* error = nil;
    NSArray* artists = [[Artist managedObjectContext] executeFetchRequest:[Artist fetchRequestWithSort:@"resourceId ASC" andPredicate:nil] error:&error];
    GHAssertNULL(error, @"There should be no errors in the allLocalArtists convenience method");
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
}

- (void) performRequestsAsynchronously {
    [CoreManager main].bundleRequestDelay = 0.1;   // Add delay to request so it performs asynchronously
}



#pragma mark -
#pragma mark GHUnit Configuration

- (BOOL)shouldRunOnMainThread { return NO; }

- (void) setUpClass {
    self.delegatesCalled = [NSMutableDictionary dictionary];
    [CoreManager main].useBundleRequests = YES;
}

- (void)tearDown {
    for (Artist* artist in [self allLocalArtists])
        [[artist managedObjectContext] deleteObject:artist];
}


@end