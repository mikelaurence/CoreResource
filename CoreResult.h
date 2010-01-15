//
//  CoreResult.h
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Punkbot LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreRequest.h"

@interface CoreResult : NSObject {
    CoreRequest* request;
    NSArray* resources;
    NSError* error;
}

@property (nonatomic, retain) CoreRequest* request;
@property (nonatomic, retain) NSArray* resources;
@property (nonatomic, retain) NSError* error;

- (id) initWithResource:(id)resource;
- (id) initWithResources:(NSArray*)resourceArray;

@end
