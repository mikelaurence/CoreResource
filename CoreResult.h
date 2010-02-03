//
//  CoreResult.h
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreRequest.h"

@class CoreModel;

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

/*
  Returns a single resource (specifically, the first object in the resources array).
  This is a convenience method for when you know you'll only have one result or when you just don't care.
*/
- (CoreModel*) resource;

- (BOOL) hasAnyResources;
- (int) resourceCount;

@end
