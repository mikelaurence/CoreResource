#import "GHUnit.h"
#import "Artist.h"

@interface CoreModelTests : GHTestCase {}
@end

@implementation CoreModelTests

- (BOOL)shouldRunOnMainThread { return NO; }
- (void)setUpClass {}
- (void)tearDownClass {}
- (void)setUp {}
- (void)tearDown {}   

// Method implementations
NSString* remoteCollectionName(id self, SEL _cmd) {
    return @"test_artists";
}

- (void)testFoo {
    // Assert a is not NULL, with no custom error description
    //GHAssertNotNULL(nil, nil);
    
    NSLog(@"Base collection name: %@", [Artist remoteCollectionName]);
    SwizzleMethod([Artist class], @selector(remoteCollectionName), [self class], @selector(remoteCollectionNm), NO);
    
    NSLog(@"Swizzled collection name: %@", [Artist remoteCollectionName]);

    // Assert equal objects, add custom error description
    //GHAssertEqualObjects([NSNull null], [NSNull null], @"Foo should be equal to: %@. Something bad happened", nil);
}

+ (NSString*) remoteCollectionNm {
    return @"woohoo";
}

@end