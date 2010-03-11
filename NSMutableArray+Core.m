//
//  NSMutableArray+core.m
//
//  Created by Mike Laurence on 1/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "NSMutableArray+Core.h"
#import "NSArray+Core.h"


@implementation NSMutableArray (Core)

#pragma mark -
#pragma mark Sorting

- (void) sortUsingKey:(id)key ascending:(BOOL)ascending {
    [self sortUsingFunction:ascending ? ascendingSort : descendingSort context:key];
}



#pragma mark -
#pragma mark Padding

- (void) padToSize:(int)size {
    [self padToSize:size withObject:[NSNull null]];
}

- (void) padToSize:(int)size withInstancesOfClass:(Class)klass {
    for (int i = [self count]; i < size; i++) {
        id obj = [[klass alloc] init];
        if ([obj respondsToSelector:@selector(setIndex:)]) {
            [obj performSelector:@selector(setIndex:) withObject:[NSNumber numberWithInt:i]];
        }
        [self addObject:obj];
    }
}

- (void) padToSize:(int)size withObject:(id)obj {
    for (int i = [self count]; i < size; i++)
        [self addObject:obj];
}

- (void) padOrTruncateToSize:(int)size withInstancesOfClass:(Class)klass {
    if (size > [self count])
        [self padToSize:size withInstancesOfClass:klass];
    else if (size < [self count])
        [self removeObjectsInRange:NSMakeRange(size, [self count] - size)];
}

@end
