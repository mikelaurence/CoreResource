//
//  CoreResourceSerializationTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"
#import "CoreDeserializer.h"
#import "User.h"
#import "JSON.h"


@interface CoreResourceSerializationTests : CoreResourceTestCase {}
@end

@implementation CoreResourceSerializationTests


#pragma mark -
#pragma mark Tests - Serialization

- (void) testDeserializerFormatByContentType {
    // Test "Content-Type" header determination
    CoreRequest* req1 = [[CoreRequest alloc] init];
    [req1 performSelector:@selector(setResponseHeaders:) withObject:$D(@"application/json", @"Content-Type")];
    CoreDeserializer* cd1 = [[CoreDeserializer alloc] initWithSource:req1 andResourceClass:[Artist class]];
    GHAssertEqualStrings(cd1.format, @"json", nil);
}

- (void) testDeserializerFormatByAcceptHeader {
    // Test "Accept" header determination
    CoreRequest* req2 = [[CoreRequest alloc] init];
    [req2 setRequestHeaders:$D(@"application/xml", @"Accept")];
    CoreDeserializer* cd2 = [[CoreDeserializer alloc] initWithSource:req2 andResourceClass:[Artist class]];
    GHAssertEqualStrings(cd2.format, @"xml", nil);
}
    
- (void) testDeserializerFormatByURL {
    // Test URL determination
    CoreRequest* req3 = [[CoreRequest alloc] initWithURL:[NSURL URLWithString:@"http://coreresource.org/pings.json"]];
    [req3 setRequestHeaders:$D(@"application/json", @"Accept")];
    CoreDeserializer* cd3 = [[CoreDeserializer alloc] initWithSource:req3 andResourceClass:[Artist class]];
    GHAssertEqualStrings(cd3.format, @"json", nil);
}

- (void) testDeserializerFormatByStringContent {
    // Test JSON string determination
    CoreDeserializer* cd4 = [[CoreDeserializer alloc] initWithSource:@" \n[{\"title\":\"value\"}]\n" andResourceClass:[Artist class]];
    GHAssertEqualStrings(cd4.format, @"json", nil);
    
    // Test XML string determination
    CoreDeserializer* cd5 = [[CoreDeserializer alloc] initWithSource:@" <artist><title>Value</title></artist>" andResourceClass:[Artist class]];
    GHAssertEqualStrings(cd5.format, @"xml", nil);
}


/*

NOTE: Test should be re-written with a different model altogether to avoid confusion.

- (void) testLocalNameForRemoteField { 
    // Override Artist's localNameForRemoteField method using this class as a source
    SwizzleMethod([Artist class], @selector(localNameForRemoteField:), [self class], @selector(localNameForRemoteField:), NO);

    Artist* artist = [Artist create:[[self artistDataJSON:@"artists.0.alternate-field-names"] JSONValue]];
    GHAssertEqualStrings(artist.theName, @"Peter Gabriel", nil);
    GHAssertEqualStrings(artist.theSummary, @"Peter Brian Gabriel is an English musician and songwriter.", nil);
    
    // Revert Artist's localNameForRemoteField method
    SwizzleMethod([Artist class], @selector(localNameForRemoteField:), [User class], @selector(localNameForRemoteField:), NO);
}
*/

/*
- (void) testRemoteNameForLocalField { GHFail(nil); }
- (void) testAlteredLocalIdField { GHFail(nil); }
- (void) testAlteredRemoteIdField { GHFail(nil); }
- (void) testAlteredDateParser { GHFail(nil); }
- (void) testDateParserForField:(NSString*)field { GHFail(nil); }

*/

/*
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

- (void) testPropertiesWithNoOptions {
    Artist* firstArtist = [self loadArtist:0];
    NSDictionary* props = [firstArtist properties:nil];
    
    GHAssertEquals((NSInteger) [props count], 6, nil);
    GHAssertEquals([props objectForKey:@"resourceId"], firstArtist.resourceId, nil);
    GHAssertEquals([props objectForKey:@"name"], firstArtist.name, nil);
    GHAssertEquals([props objectForKey:@"summary"], firstArtist.summary, nil);
    GHAssertEquals([props objectForKey:@"detail"], firstArtist.detail, nil);
    GHAssertEquals([props objectForKey:@"updatedAt"], firstArtist.updatedAt, nil);
    GHAssertTrue([[props objectForKey:@"songs"] isKindOfClass:[NSArray class]], nil);
    GHAssertEquals((NSInteger) [[props objectForKey:@"songs"] count], 0, nil);
}

- (void) testPropertiesWithOnlyOption {
    Artist* firstArtist = [self loadArtist:0];
    NSDictionary* props = [firstArtist properties:$D($A(@"name", @"summary"), @"$only")];
    GHAssertEquals((NSInteger) [props count], 2, nil);
    GHAssertEquals([props objectForKey:@"name"], firstArtist.name, nil);
    GHAssertEquals([props objectForKey:@"summary"], firstArtist.summary, nil);
}

- (void) testPropertiesWithExceptOption {
    Artist* firstArtist = [self loadArtist:0];
    NSDictionary* props = [firstArtist properties:$D($A(@"detail", @"name"), @"$except")];
    GHAssertEquals((NSInteger) [props count], 4, nil);
    GHAssertEquals([props objectForKey:@"resourceId"], firstArtist.resourceId, nil);
    GHAssertEquals([props objectForKey:@"summary"], firstArtist.summary, nil);
    GHAssertEquals([props objectForKey:@"updatedAt"], firstArtist.updatedAt, nil);
    GHAssertTrue([[props objectForKey:@"songs"] isKindOfClass:[NSArray class]], nil);
    GHAssertEquals((NSInteger) [[props objectForKey:@"songs"] count], 0, nil);
}

- (void) testPropertiesWithRelationshipsAndNoOptions {
    Artist* secondArtist = [self loadArtist:1];
    NSDictionary* props = [secondArtist properties];
    GHAssertEquals((NSInteger) [props count], 6, nil);

    NSArray* songs = [[props objectForKey:@"songs"] sortedArrayUsingFunction:ascendingSort context:@"name"];
    GHAssertEquals((NSInteger) [songs count], 2, nil);
    GHAssertEqualStrings([[songs objectAtIndex:0] objectForKey:@"name"], @"Don't Make Me a Target", nil);
    GHAssertEqualStrings([[songs objectAtIndex:1] objectForKey:@"name"], @"You Got Yr. Cherry Bomb", nil);
}

- (void) testToJson {
    Artist* secondArtist = [self loadArtist:1];
    NSString* secondArtistJson = [secondArtist toJson];
    NSDictionary* props = [secondArtistJson JSONValue];
    GHAssertEquals((NSInteger) [props count], 6, nil);
    GHAssertEquals([[props objectForKey:@"resourceId"] intValue], [secondArtist.resourceId intValue], nil);
    GHAssertEqualStrings([props objectForKey:@"name"], secondArtist.name, nil);
    GHAssertEqualStrings([props objectForKey:@"summary"], secondArtist.summary, nil);
    GHAssertEqualStrings([props objectForKey:@"detail"], secondArtist.detail, nil);
    GHAssertEqualStrings([props objectForKey:@"updatedAt"], [[Artist dateParser] stringFromDate:secondArtist.updatedAt], nil);
}
*/


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

/*
+ (NSString*) localNameForRemoteField:(NSString*)name {
    NSString* alt = [[NSDictionary dictionaryWithObjectsAndKeys:
        @"theName", @"name",
        @"theSummary", @"summary",
        @"theDescription", @"description", nil]
        objectForKey:name];
    return alt != nil ? alt : name;
}
*/


@end