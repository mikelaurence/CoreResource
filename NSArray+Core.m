//
//  NSArray+Core.m
//  CoreTest
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "NSArray+Core.h"


@implementation NSArray (Core)

#pragma mark -
#pragma mark Sorting

- (NSArray*) sortedArrayUsingKey:(id)key ascending:(BOOL)ascending {
    return [self sortedArrayUsingFunction:ascending ? ascendingSort : descendingSort context:key];
}

NSInteger ascendingSort(id obj1, id obj2, void *key) {
    return [[obj1 objectForKey:key] compare:[obj2 objectForKey:key]];
}

NSInteger descendingSort(id obj1, id obj2, void *key) {
    return [[obj2 objectForKey:key] compare:[obj1 objectForKey:key]];
}

@end
