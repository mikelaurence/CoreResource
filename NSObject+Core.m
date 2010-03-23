//
//  NSObject+Core.m
//  Core Resource
//
//  Created by Mike Laurence on 2/8/10.
//

#import "NSObject+Core.h"


@implementation NSObject (Core)

- (id) get:(SEL)selector {
    return [self respondsToSelector:selector] ? [self performSelector:selector] : nil;
}

- (id) get:(SEL)selector orDefault:(id)defaultValue {
    if ([self respondsToSelector:selector]) {
        id val = [self performSelector:selector];
        if (val != nil)
            return val;
    }
    return defaultValue;
}

- (BOOL) isCollection {
    return [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSSet class]];
}

@end
