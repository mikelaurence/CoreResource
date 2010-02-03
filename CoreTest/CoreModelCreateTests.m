//
//  CoreModelCreateTests.m
//  CoreTest
//
//  Created by Mike Laurence on 1/19/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "CoreResourceTestCase.h"

@interface CoreModelCreateTests : CoreResourceTestCase {}
@end

@implementation CoreModelCreateTests

#pragma mark -
#pragma mark Create

- (void) testCreate { 
    NSDictionary* paramsOne = [[self artistData] objectAtIndex:0];
    Artist* artistOne = [Artist create:paramsOne];
    [self validateFirstArtist:artistOne];
    
    NSDictionary* paramsTwo = [[self artistData] objectAtIndex:1];
    Artist* artistTwo = [Artist create:paramsTwo];
    [self validateSecondArtist:artistTwo];
}

/*
- (void) testCreateOrUpdateWithDictionary { GHFail(nil); }
- (void) testCreateOrUpdateWithDictionaryAndRelationship { GHFail(nil); }
- (void) testUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }
- (void) testShouldUpdateWithDictionary:(NSDictionary*)dict { GHFail(nil); }
*/

@end
