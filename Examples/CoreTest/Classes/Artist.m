//
//  Artist.m
//  CoreTest
//
//  Created by Mike Laurence on 1/14/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "Artist.h"
#import "CoreUtils.h"


@implementation Artist

@dynamic detail;
@dynamic name;
@dynamic resourceId;
@dynamic songs;
@dynamic summary;
@dynamic updatedAt;

- (NSArray*) sortedSongs {
    return [[self.songs allObjects] sortedArrayUsingDescriptors:[CoreUtils sortDescriptorsFromString:@"name ASC"]];
}

@end
