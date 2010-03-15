//
//  NSArray+Core.h
//  CoreTest
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Core)

#pragma mark -
#pragma mark Sorting
- (NSArray*) sortedArrayUsingKey:(id)key ascending:(BOOL)ascending;
NSInteger ascendingSort(id obj1, id obj2, void *key);
NSInteger descendingSort(id obj1, id obj2, void *key);

#pragma mark -
#pragma mark Mapping
- (NSArray*) arrayMappedBySelector:(SEL)selector;
- (NSArray*) arrayMappedBySelector:(SEL)selector withObject:(id)object;
- (NSDictionary*) dictionaryMappedByKey:(id)key;


@end
