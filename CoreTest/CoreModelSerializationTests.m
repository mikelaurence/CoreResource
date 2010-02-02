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
    [CoreManager main].useBundleRequests = YES;
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
- (void) testDeserializeFromString:(NSString*)serializedString { GHFail(nil); }
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