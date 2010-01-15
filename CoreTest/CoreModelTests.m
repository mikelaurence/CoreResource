#import "GHUnit.h"
#import "Artist.h"
#import "CoreResult.h"

@interface CoreModelTests : GHTestCase {}
- (NSArray*) allLocalArtists;
- (void) validateFirstArtist:(Artist*)artist;
@end

@implementation CoreModelTests

- (BOOL)shouldRunOnMainThread { return NO; }

- (void)setUpClass {
    [CoreManager main].useBundleRequests = YES;
}

- (void)tearDownClass {}
- (void)setUp {}

- (void)tearDown {
    for (Artist* artist in [self allLocalArtists])
        [[artist managedObjectContext] deleteObject:artist];
}

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
#pragma mark Tests - Configuration

- (void) testPropertyDescriptionForField {
    GHFail(nil);
}


#pragma mark -
#pragma mark Tests - Serialization

- (void) testAlteredLocalIdField { GHFail(nil); }
- (void) testAlteredRemoteIdField { GHFail(nil); }
- (void) testAlteredDateParser { GHFail(nil); }
- (void) testDateParserForField:(NSString*)field { GHFail(nil); }
- (void) testDeserializeFromString:(NSString*)serializedString { GHFail(nil); }
- (void) testAlteredDataCollectionFromDeserializedCollection { GHFail(nil); }


#pragma mark -
#pragma mark Core Data

- (void) testAlteredEntityName { GHFail(nil); }
- (void) testEntityDescription { GHFail(nil); }
- (void) testHasRelationships { GHFail(nil); }
- (void) testAlteredManagedObjectContext { GHFail(nil); }


#pragma mark -
#pragma mark Create

- (void) testCreate { GHFail(nil); }
- (void) testCreateOrUpdateWithDictionary { GHFail(nil); }
- (void) testCreateOrUpdateWithDictionaryAndRelationship { GHFail(nil); }
- (void) testUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }
- (void) testShouldUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }


#pragma mark -
#pragma mark Read


- (void) testFindWithoutLocalHit {
    GHAssertNULL([Artist find:@"1"], @"Find should not immediately return an object if the object doesn't yet exist");
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
    Artist* artist = [[self allLocalArtists] objectAtIndex:0];
    [self validateFirstArtist:artist];
}

- (void) testFindWithLocalHit {
    CoreResult* result = [Artist find:@"1"];
    GHAssertNotNULL(result, nil);
    GHAssertEquals([[result resources] count], 1, nil);
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
}

- (void) testFindAndNotify {
    [Artist find:@"1" andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 1, nil);
    GHFail(nil);
}

- (void) testFindAllWithoutLocalHits { GHFail(nil); }
- (void) testFindAllWithLocalHits { GHFail(nil); }
- (void) testFindAllAndNotify { GHFail(nil); }
- (void) findLocal:(NSString*)recordId { GHFail(nil); }
- (void) findAllLocal:(id)parameters { GHFail(nil); }
- (void) testFindRemote { GHFail(nil); }
- (void) testFindRemoteAndNotify { GHFail(nil); }
- (void) testFindAllRemote { GHFail(nil); }
- (void) testFindAllRemoteAndNotify { GHFail(nil); }



#pragma mark -
#pragma mark Results Management

- (void) testFetchRequest { GHFail(nil); }
- (void) testFetchRequestWithSortAndPredicate { GHFail(nil); }
- (void) testPredicateWithParameters { GHFail(nil); }
- (void) testCoreResultsControllerWithSortAndSection { GHFail(nil); }
- (void) testCoreResultsControllerWithRequestAndSectionKey { GHFail(nil); }




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

+ (NSString*) remoteCollectionNm {
    return @"woohoo";
}

@end