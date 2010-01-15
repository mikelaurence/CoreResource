#import "GHUnit.h"
#import "Artist.h"
#import "CoreResult.h"

@interface CoreModelTests : GHTestCase {}
@end

@implementation CoreModelTests

- (BOOL)shouldRunOnMainThread { return NO; }
- (void)setUpClass {}
- (void)tearDownClass {}
- (void)setUp {}

- (void)tearDown {
    [Artist entityDescription];
}

- (void) testFindWithoutLocalHit {
    [Artist find:@"1"];
}

- (void) testFindWithLocalHit {
    [Artist find:@"1"];
}


- (void) testFindAndNotify {
    [Artist find:@"1" andNotify:self withSelector:@selector(completeTestFindAndNotify:)];
}

- (void) completeTestFindAndNotify:(CoreResult*)result {
    
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