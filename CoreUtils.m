//
//  CoreUtils.m
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreUtils.h"
#import "TargetConditionals.h"

@implementation CoreUtils

static NSTimeInterval globalStopwatch;
+ (void) resetStopwatch { globalStopwatch = [NSDate timeIntervalSinceReferenceDate]; }
+ (NSTimeInterval) stopwatchTime { return [NSDate timeIntervalSinceReferenceDate] - globalStopwatch; }

+ (BOOL) runningInSimulator {
    #if TARGET_IPHONE_SIMULATOR
    return YES;
    #endif
    return NO;
}


/**
    Generates an array of sort descriptors based on a SQL-esque string
    Example: "lastName ASC updatedAt DESC"
*/
+ (NSArray*) sortDescriptorsFromString:(NSString*)string {
    NSMutableArray* sortDescriptors = nil;

    NSArray* sortChunks = [string componentsSeparatedByString:@" "];
    if ([sortChunks count] % 2 == 0) {
        sortDescriptors = [NSMutableArray arrayWithCapacity:[sortChunks count] / 2];
        for (int chunkIdx = 0; chunkIdx < [sortChunks count]; chunkIdx += 2) {
            [sortDescriptors addObject:
                [[[NSSortDescriptor alloc] initWithKey:[sortChunks objectAtIndex:chunkIdx] ascending:
                    [[sortChunks objectAtIndex:chunkIdx + 1] caseInsensitiveCompare:@"asc"] == NSOrderedSame] autorelease]];
        }
    }
    return sortDescriptors;
}

+ (NSArray*) sortDescriptorsFromParameters:(id)parameters {
    if ([parameters isKindOfClass:[NSString class]])
        return [self sortDescriptorsFromString:parameters];
    if ([parameters isKindOfClass:[NSDictionary class]])
        return [self sortDescriptorsFromParameters:[parameters objectForKey:@"$sort"]];
    else if ([parameters isKindOfClass:[NSArray class]])
        return parameters;
    return nil;
}

+ (NSURL*) URLWithSite:(NSString*)site andFormat:(NSString*)format andParameters:(id)parameters {
    // Build query parameter string from supplied parameters
    NSMutableString *str = [NSMutableString stringWithString:site];
    
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




#pragma mark -
#pragma mark Predicates

/**
    Generates a predicate from the following kinds of objects:
    Predicate - returns untouched
    Dictionary - keys equalling values
    String - straight transformation using predicate formatting
*/
+ (NSPredicate*) predicateFromObject:(id)object {
    return object != nil ? [[self variablePredicateFromObject:object] predicateWithSubstitutionVariables:object] : nil;
}

+ (NSPredicate*) variablePredicateFromObject:(id)object {
    if (object != nil) {
        if ([object isKindOfClass:[NSPredicate class]])
            return object;
            
        if ([object isKindOfClass:[NSString class]])
            return [NSPredicate predicateWithFormat:(NSString*)object];

        if ([object isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:[object count]];
            for (NSString *key in object) {
                if (![key hasPrefix:@"$"])
                    [predicates addObject:[self equivalencyPredicateForKey:key]];
            }
            
            return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        }
    }

    return [NSPredicate predicateWithValue:YES];
}

+ (NSPredicate*) equivalencyPredicateForKey:(NSString*)key {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:key] 
        rightExpression:[NSExpression expressionForVariable:key]
        modifier:NSDirectPredicateModifier 
        type:NSEqualToPredicateOperatorType 
        options:0];
}



@end