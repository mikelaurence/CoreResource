//
//  NSObject+Core.h
//  Core Resource
//
//  Created by Mike Laurence on 2/8/10.
//

#import <Foundation/Foundation.h>


@interface NSObject (Core)

- (id) get:(SEL)selector;
- (id) get:(SEL)selector orDefault:(id)defaultValue;
- (BOOL) isCollection;

@end
