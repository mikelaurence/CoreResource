//
//  Song.h
//  CoreTest
//
//  Created by Mike Laurence on 1/25/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreModel.h"

@class Artist;

@interface Song : CoreModel {
}

@property (nonatomic, retain) Artist * artist;

@end
