//
//  NSSet+Core.m
//  Core Resource
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "NSSet+Core.h"


@implementation NSSet (Core)

- (NSSet*) intersection:(NSSet*)otherSet {
    NSMutableSet *intersection = [self mutableCopy];
	[intersection intersectSet:otherSet];
	return intersection;
}

- (NSSet*) difference:(NSSet*)otherSet {
    NSMutableSet *difference = [self mutableCopy];
    [difference minusSet:otherSet];
    return difference;
}

- (id) objectOfClass:(Class)clazz {
    for (id obj in self) {
        if ([obj isKindOfClass:clazz])
            return obj;
    }
    return nil;
}

@end
