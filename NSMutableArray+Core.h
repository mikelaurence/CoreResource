//
//  NSMutableArray+core.h
//
//  Created by Mike Laurence on 1/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Core)

- (void) padToSize:(int)size;
- (void) padToSize:(int)size withInstancesOfClass:(Class)klass;
- (void) padToSize:(int)size withObject:(id)obj;

- (void) padOrTruncateToSize:(int)size withInstancesOfClass:(Class)klass;

@end
