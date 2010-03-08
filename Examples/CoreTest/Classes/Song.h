//
//  Song.h
//  CoreTest
//
//  Created by Mike Laurence on 1/25/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreResource.h"

@class Artist;

@interface Song : CoreResource {
}

@property (nonatomic, retain) Artist * artist;

@end
