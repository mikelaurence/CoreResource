//
//  Ticket.h
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseResource.h"


@interface Ticket : LighthouseResource {
}

@property (nonatomic, retain) NSString * assignedUserName;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * creatorName;
@property (nonatomic, retain) NSString * latestBody;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * permalink;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * url;


@end
