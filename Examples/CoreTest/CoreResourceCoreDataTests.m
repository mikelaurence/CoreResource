//
//  CoreResourceCoreDataTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"
#import "Artist.h"
#import "Song.h"
#import "User.h"

@interface CoreResourceCoreDataTests : CoreResourceTestCase {}
@end

@implementation CoreResourceCoreDataTests

#pragma mark -
#pragma mark Core Data

- (void) testEntityName { 
    GHAssertEqualStrings([Artist entityName], @"Artist", nil);
    GHAssertEqualStrings([Song entityName], @"Song", nil);
}

- (void) testEntityDescription { 
    NSEntityDescription* artistDescription = [NSEntityDescription entityForName:@"Artist" inManagedObjectContext:[[CoreManager main] managedObjectContext]];
    GHAssertEquals([Artist entityDescription], artistDescription, nil);
}

- (void) testHasRelationships { 
    GHAssertTrue([Artist hasRelationships], nil);
    GHAssertTrue([Song hasRelationships], nil);
    GHAssertFalse([User hasRelationships], nil);
}

@end
