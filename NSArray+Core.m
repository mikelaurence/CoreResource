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


#pragma mark -
#pragma mark Mapping

- (NSArray*) arrayMappedBySelector:(SEL)selector {
    return [self arrayMappedBySelector:selector withObject:nil];
}

- (NSArray*) arrayMappedBySelector:(SEL)selector withObject:(id)object {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    for (id obj in self) {
        if ([obj respondsToSelector:selector])
            [array addObject:[obj performSelector:selector withObject:object]];
    }
    return array;
}

- (NSDictionary*) dictionaryMappedByKey:(id)key {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    for (id obj in self)
        [dict setObject:obj forKey:[obj valueForKey:key]];
    return dict;
}



@end
