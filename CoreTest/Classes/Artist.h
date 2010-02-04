//
//  Artist.h
//  CoreTest
//
//  Created by Mike Laurence on 1/14/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"


@interface Artist : CoreModel {
}

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * resourceId;
@property (nonatomic, retain) NSArray * songs;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * updatedAt;

@end
