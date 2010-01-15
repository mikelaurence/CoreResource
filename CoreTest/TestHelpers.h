//
//  TestHelpers.h
//  CoreTest
//
//  Created by Mike Laurence on 1/15/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestHelpers : NSObject {
}

void SwizzleMethod(Class destClass, SEL destSelector, Class origClass, SEL origSelector, BOOL isInstanceMethod);

@end
