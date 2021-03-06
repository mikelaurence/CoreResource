//
//  Artist.h
//  CoreTest
//
//  Created by Mike Laurence on 1/14/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreResource.h"


@interface Artist : CoreResource {
}

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * resourceId;
@property (nonatomic, retain) NSSet * songs;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * updatedAt;

- (NSArray*) sortedSongs;

@end
