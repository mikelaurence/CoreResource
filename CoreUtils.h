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
#define $S(format, ...) [NSString stringWithFormat:format, ## __VA_ARGS__]
#define $I(i) [NSNumber numberWithInt:i]
#define $F(f) [NSNumber numberWithFloat:f]
#define $B(b) ((b) ? (id)kCFBooleanTrue : (id)kCFBooleanFalse)

#pragma mark -
#pragma mark Misc macros
#define ToArray(object) (object != nil ? ([object isKindOfClass:[NSArray class]] ? object : [NSArray arrayWithObject:object]) : [NSArray array])
#define Log(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ## __VA_ARGS__]);
#define StartTimer NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
#define EndTimer(msg) NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; Log([NSString stringWithFormat:@"%@ Time = %f", msg, stop-start]);

#pragma mark -
#pragma mark Global stopwatch
+ (void) resetStopwatch;
+ (NSTimeInterval) stopwatchTime;
#define ResetStopwatch [CoreUtils resetStopwatch];
#define LogStopwatch(msg) Log($S(@"%@ Stopwatch = %f", msg, [CoreUtils stopwatchTime]));


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
