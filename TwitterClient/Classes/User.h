//
//  User.h
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterModel.h"

@class Status;

@interface User : TwitterModel {
}

@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSNumber *following;
@property (nonatomic, retain) NSNumber *friendsCount;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *profileImageUrl;
@property (nonatomic, retain) NSNumber *resourceId;
@property (nonatomic, retain) NSNumber *statusesCount;
@property (nonatomic, retain) NSSet *statuses;

@end
