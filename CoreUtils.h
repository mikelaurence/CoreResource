//
//  CoreUtils.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

@interface CoreUtils : NSObject {
}

#pragma mark -
#pragma mark Instantiation macros

#define $D(...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
#define $A(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define $S(...) [NSString stringWithFormat: __VA_ARGS__]
#define $I(_X_) [NSNumber numberWithInt:_X_]
#define $F(_X_) [NSNumber numberWithFloat:_X_]
#define $B(_X_) ((_X_) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse)

#pragma mark -
#pragma mark Generic utilities
+ (BOOL) runningInSimulator;

#pragma mark -
#pragma mark Helpers
+ (NSArray*) sortDescriptorsFromString:(NSString*)string;
+ (NSArray*) sortDescriptorsFromParameters:(id)parameters;
+ (NSURL*) URLWithSite:(NSString*)site andFormat:(NSString*)format andParameters:(id)parameters;

#pragma mark -
#pragma mark Predicates
+ (NSPredicate*) variablePredicateFromObject:(id)object;
+ (NSPredicate*) predicateFromObject:(id)object;
+ (NSPredicate*) equivalencyPredicateForKey:(NSString*)key;

@end
