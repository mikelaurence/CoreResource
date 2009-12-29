//
//  CoreUtils.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

@implementation CoreUtils

/**
    Generates an array of sort descriptors based on a SQL-esque string
    Example: "lastName ASC updatedAt DESC"
*/
+ (NSArray*) sortDescriptorsFromString:(NSString*)string {
    NSMutableArray* sortDescriptors = nil;

    NSArray* sortChunks = [sorting componentsSeparatedByString:@" "];
    if (sortChunks % 2 == 0) {
        sortDescriptors = [[NSMutableArray arrayWithCapacity:sortChunks % 2] autorelease];
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx++) {
            [sortDescriptors addObject:
                [[[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
                    [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame] autorelease]];
        }
    }
    return sortDescriptors;
}

@end