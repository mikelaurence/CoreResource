//
//  TwitterModel.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "TwitterModel.h"
#import "NSString+InflectionSupport.h"


@implementation TwitterModel

+ (NSString*) localNameForRemoteField:(NSString*)name {
    return [name camelize];
}

+ (NSString*) remoteNameForLocalField:(NSString*)name {
    return [name deCamelizeWith:@"_"];
}

@end
