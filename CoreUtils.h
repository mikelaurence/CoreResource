//
//  CoreUtils.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

@interface CoreUtils : NSObject {
}

+ (BOOL) runningInSimulator;
+ (NSPredicate*) predicateFromObject:(id)object;
+ (NSArray*) sortDescriptorsFromString:(NSString*)string;
+ (NSURL*) URLWithSite:(NSString*)site andFormat:(NSString*)format andParameters:(id)parameters;

@end
