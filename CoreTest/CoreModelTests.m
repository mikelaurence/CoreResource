#import "GHUnit.h"
#import "Artist.h"
#import "CoreResult.h"

@interface CoreModelTests : GHTestCase {}
- (NSArray*) allLocalArtists;
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



#pragma mark -
#pragma mark Tests

- (void) testFindWithoutLocalHit {
    GHAssertNULL([Artist find:@"1"], @"Find should not immediately return an object if the object doesn't yet exist");
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
}

- (void) testFindWithLocalHit {
    CoreResult* result = [Artist find:@"1"];
    GHAssertEquals([[result resources] count], 1, nil);
    GHAssertEquals([[self allLocalArtists] count], 1, nil);
}


- (void) testFindAndNotify {
    [Artist find:@"1" andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    GHAssertEquals([[result resources] count], 1, nil);
}



- (void) testRemoteCollectionName {
    // Assert a is not NULL, with no custom error description
    //GHAssertNotNULL(nil, nil);
    
   // NSLog(@"Base collection name: %@", [Artist remoteCollectionName]);
    //SwizzleMethod([Artist class], @selector(remoteCollectionName), [self class], @selector(remoteCollectionNm), NO);

    // Assert equal objects, add custom error description
    //GHAssertEqualObjects([NSNull null], [NSNull null], @"Foo should be equal to: %@. Something bad happened", nil);
}

+ (NSString*) remoteCollectionNm {
    return @"woohoo";
}

@end