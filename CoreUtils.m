//
//  CoreUtils.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#include "CoreUtils.h"

@implementation CoreUtils

/**
    Generates an array of sort descriptors based on a SQL-esque string
    Example: "lastName ASC updatedAt DESC"
*/
+ (NSArray*) sortDescriptorsFromString:(NSString*)string {
    NSMutableArray* sortDescriptors = nil;

    NSArray* sortChunks = [string componentsSeparatedByString:@" "];
    if ([sortChunks count] % 2 == 0) {
        sortDescriptors = [[NSMutableArray arrayWithCapacity:[sortChunks count] % 2] autorelease];
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx++) {
            [sortDescriptors addObject:
                [[[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
                    [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame] autorelease]];
        }
    }
    return sortDescriptors;
}

+ (NSURL*) URLWithSite:(NSString*)site andParameters:(id)parameters {
    // Build query parameter string from supplied parameters
    NSString *paramsString = nil;
    if ([parameters isKindOfClass:[NSString class]])
        paramsString = parameters;
    else if ([parameters isKindOfClass:[NSDictionary class]]) {
        BOOL first = YES;
        NSMutableString *str = [[NSMutableString string] autorelease];
        for (NSString *key in [(NSDictionary*)parameters allKeys]) {
            if (!first) {
                [str appendString:@"&"];
                first = NO;
            }
            [str appendString:[NSString stringWithFormat:@"%@=%@", key, [(NSDictionary*)parameters objectForKey:key]]];
        }
        paramsString = str;
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", site, paramsString]]; 
}

@end