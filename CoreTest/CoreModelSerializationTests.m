//
//  CoreModelSerializationTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelSerializationTests : CoreResourceTestCase {}
@end

@implementation CoreModelSerializationTests

- (void)setUpClass {
    [super setUpClass];
}


#pragma mark -
#pragma mark Tests - Serialization
/*
- (void) testLocalNameForRemoteField { GHFail(nil); }
- (void) testRemoteNameForLocalField { GHFail(nil); }
- (void) testAlteredLocalIdField { GHFail(nil); }
- (void) testAlteredRemoteIdField { GHFail(nil); }
- (void) testAlteredDateParser { GHFail(nil); }
- (void) testDateParserForField:(NSString*)field { GHFail(nil); }

*/

- (void) testDeserializeFromString {
    [self loadAllArtists];
    
    NSString* artist0String = [self artistDataJSON:@"artists.0"];
    NSArray* deserializedArtist = [Artist deserializeFromString:artist0String];
    int artistCt = [deserializedArtist count];
    GHAssertEquals(artistCt, 1, nil);
    [self validateFirstArtist:[deserializedArtist lastObject]];

    NSString* artistsString = [self artistDataJSON:@"artists"];
    NSArray* deserializedArtistCollection = [Artist deserializeFromString:artistsString];
    int collectionCt = [deserializedArtistCollection count];
    GHAssertEquals(collectionCt, 3, nil);
    NSArray* sortedResources = [deserializedArtistCollection sortedArrayUsingDescriptors:
        [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"resourceId" ascending:YES]]];
    
    [self validateFirstArtist:[sortedResources objectAtIndex:0]];
    [self validateSecondArtist:[sortedResources objectAtIndex:1]];
}

/*
- (void) testAlteredDataCollectionFromDeserializedCollection { GHFail(nil); }

- (void) testRemoteCollectionName {
    // Assert a is not NULL, with no custom error description
    //GHAssertNotNULL(nil, nil);
    
    // NSLog(@"Base collection name: %@", [Artist remoteCollectionName]);
    //SwizzleMethod([Artist class], @selector(remoteCollectionName), [self class], @selector(remoteCollectionNm), NO);

    // Assert equal objects, add custom error description
    //GHAssertEqualObjects([NSNull null], [NSNull null], @"Foo should be equal to: %@. Something bad happened", nil);
    GHFail(nil);
}



#pragma mark -
#pragma mark Runtime method implementations

+ (NSString*) remoteCollectionName {
    return @"woohoo";
}
*/

@end