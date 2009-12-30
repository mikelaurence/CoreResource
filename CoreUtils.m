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
        sortDescriptors = [[NSMutableArray arrayWithCapacity:[sortChunks count] / 2] autorelease];
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx += 2) {
            [sortDescriptors addObject:
                [[[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
                    [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame] autorelease]];
        }
    }
    return sortDescriptors;
}

+ (NSURL*) URLWithSite:(NSString*)site andFormat:(NSString*)format andParameters:(id)parameters {
    // Build query parameter string from supplied parameters
    NSMutableString *str = [[NSMutableString stringWithString:site] autorelease];
    
    // Add in format if extant
    if (format != nil) {
        [str appendString:@"."];
        [str appendString:format];
    }
    
    if (parameters != nil) {
        [str appendString:@"?"];
        
        // If parameters are just a string, add in directly
        if ([parameters isKindOfClass:[NSString class]])
            [str appendString:parameters];
            
        // If parameters are a dictionary, iterate and add each pair
        else if ([parameters isKindOfClass:[NSDictionary class]]) {
            BOOL first = YES;
            for (NSString *key in [(NSDictionary*)parameters allKeys]) {
                if (first) first = NO;
                else [str appendString:@"&"];
                [str appendString:[NSString stringWithFormat:@"%@=%@", key, [(NSDictionary*)parameters objectForKey:key]]];
            }
        }
    }
    
    return [NSURL URLWithString:str];
}

@end