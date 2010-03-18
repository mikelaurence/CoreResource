//
//  CoreResult.h
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreRequest.h"

@class CoreResource;

@interface CoreResult : NSObject <NSFastEnumeration> {
    id source;
    NSArray* resources;
    NSError* error;
}

@property (nonatomic, retain) id source;
@property (nonatomic, retain) NSArray* resources;
@property (nonatomic, retain) NSError* error;

- (id) initWithResources:(id)resources;
- (id) initWithSource:(id)source andResources:(id)resources;
- (id) initWithError:(NSError*)error;

/*
  Returns a single resource (specifically, the first object in the resources array).
  This is a convenience method for when you know you'll only have one result or when you just don't care.
*/
- (CoreResource*) resource;

- (BOOL) hasAnyResources;
- (int) resourceCount;

@end
