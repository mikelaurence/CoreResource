//
//  Ticket.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "Ticket.h"


@implementation Ticket

@dynamic assignedUserName;
@dynamic closed;
@dynamic createdAt;
@dynamic creatorName;
@dynamic latestBody;
@dynamic priority;
@dynamic number;
@dynamic permalink;
@dynamic title;
@dynamic updatedAt;
@dynamic url;

+ (NSString*) localIdField {
    return @"number";
}

+ (NSString*) remoteIdField {
    return @"number";
}

@end
