//
//  CoreModelCreateTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelCreateTests : CoreResourceTestCase {}
@end

@implementation CoreModelCreateTests

#pragma mark -
#pragma mark Create

- (void) testCreate { 
    Artist* artistOne = [Artist create:[self artistData:0]];
    [self validateFirstArtist:artistOne];
    
    Artist* artistTwo = [Artist create:[self artistData:1]];
    [self validateSecondArtist:artistTwo];
}

/*
- (void) testCreateOrUpdateWithDictionary { GHFail(nil); }
- (void) testCreateOrUpdateWithDictionaryAndRelationship { GHFail(nil); }
- (void) testUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }
- (void) testShouldUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }
*/

@end
