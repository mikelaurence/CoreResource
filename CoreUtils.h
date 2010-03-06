//
//  CoreUtils.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

@interface CoreUtils : NSObject {
}

NSDictionary* $D(id firstKey, ...);

+ (BOOL) runningInSimulator;
+ (NSArray*) sortDescriptorsFromString:(NSString*)string;
+ (NSArray*) sortDescriptorsFromParameters:(id)parameters;
+ (NSURL*) URLWithSite:(NSString*)site andFormat:(NSString*)format andParameters:(id)parameters;

#pragma mark -
#pragma mark Predicates
+ (NSPredicate*) variablePredicateFromObject:(id)object;
+ (NSPredicate*) predicateFromObject:(id)object;
+ (NSPredicate*) equivalencyPredicateForKey:(NSString*)key;

@end
