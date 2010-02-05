//
//  NSSet+Core.m
//  Core Resource
//
//  Created by Mike Laurence on 2/5/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "NSSet+Core.h"


@implementation NSSet (Core)

- (id) objectOfClass:(Class)clazz {
    for (id obj in self) {
        if ([obj isKindOfClass:clazz])
            return obj;
    }
    return nil;
}

@end
