//
//  Ping.h
//  CorePing
//
//  Created by Mike Laurence on 3/8/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreResource.h"


@interface Ping : CoreResource {}

@property (nonatomic, retain) NSDate *created_at; 
@property (nonatomic, retain) NSString *device; 
@property (nonatomic, retain) NSNumber *latitude; 
@property (nonatomic, retain) NSNumber *longitude; 
@property (nonatomic, retain) NSString *message; 
@property (nonatomic, retain) NSString *name;

@end
