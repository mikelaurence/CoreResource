//
//  MiscBenchmarks.m
//  CoreTest
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//


#import "CoreResourceTestCase.h"

@interface MiscBenchmarks : CoreResourceTestCase {
    // Cached pointers
    Artist* artist;
    NSString* value;
    NSString* readKey;
    NSString* writeKey;
    SEL readSel, writeSel;
}
@end

@implementation MiscBenchmarks

#define ITERATE for (int i = 0; i < 1000000; i++)

- (void) setUp {
    artist = [[self loadArtist:0] retain];
    readKey = [@"name" retain];
    readSel = @selector(name);
    writeKey = [@"setName" retain];
    writeSel = @selector(setName:);
}

- (void) testReadsUsingDynamicGetters {
    ITERATE value = artist.name;
}

- (void) testReadsUsingKVC {
    ITERATE value = [artist valueForKey:readKey];
}

- (void) testReadsUsingPrimitiveKVC {
    ITERATE value = [artist primitiveValueForKey:readKey];
}

- (void) testReadsUsingSelector {
    ITERATE value = [artist performSelector:readSel];
}

- (void) testReadsUsingConvertedSelector {
    ITERATE value = [artist performSelector:NSSelectorFromString(readKey)];
}

- (void) testWritesUsingDynamicSetters {
    ITERATE artist.name = @"Schpoon";
}

- (void) testWritesUsingKVC {
    ITERATE [artist setValue:@"Schpoon" forKey:@"name"];
}

- (void) testWritesUsingPerformSelector {
    ITERATE value = [artist performSelector:writeSel withObject:@"Schpoon"];
}

@end
