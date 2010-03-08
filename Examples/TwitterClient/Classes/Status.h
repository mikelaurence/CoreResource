//
//  Status.h
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterModel.h"

@class User;

@interface Status : TwitterModel {
}

@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSNumber *resourceId;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) User *user;

@end