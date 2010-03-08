//
//  Status.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import "Status.h"


@implementation Status

@dynamic createdAt;
@dynamic resourceId;
@dynamic text;
@dynamic user;

+ (NSString*) remoteURLForCollectionAction:(Action)action {
    return @"http://twitter.com/statuses/public_timeline";
}

+ (NSString*) bundlePathForCollectionAction:(Action)action {
    return @"users.mikelaurence";
}

@end
