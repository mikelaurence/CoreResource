//
//  CoreResult.m
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import "CoreResult.h"


@implementation CoreResult

@synthesize request;
@synthesize resources;
@synthesize error;

- (id) initWithResource:(id)resource {
    if (self = [super init])
        self.resources = [NSArray arrayWithObject:resource];
    return self;
}

- (id) initWithResources:(NSArray*)resourceArray {
    if (self = [super init])
        self.resources = resourceArray;
    return self;
}

- (id) initWithError:(NSError*)theError {
    if (self = [super init])
        self.error = theError;
    return self;
}

- (CoreResource*) resource {
    return resources != nil && [resources count] > 0 ? [resources objectAtIndex:0] : nil;
}

- (BOOL) hasAnyResources {
    return [self resourceCount] > 0;
}

- (int) resourceCount {
    return resources != nil ? [resources count] : 0;
}

@end
