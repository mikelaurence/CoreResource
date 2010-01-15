//
//  TestHelpers.m
//  CoreTest
//
//  Created by Mike Laurence on 1/15/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "TestHelpers.h"
#import </usr/include/objc/objc-class.h>


@implementation TestHelpers

void SwizzleMethod(Class destClass, SEL destSelector, Class origClass, SEL origSelector, BOOL isInstanceMethod) {
    Method dMethod = class_getClassMethod(isInstanceMethod ? destClass : destClass->isa, destSelector);
    Method oMethod = class_getClassMethod(isInstanceMethod ? origClass : origClass->isa, origSelector);
    if(!class_addMethod(isInstanceMethod ? destClass : destClass->isa, destSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod)))
        method_exchangeImplementations(dMethod, oMethod);
}

@end
