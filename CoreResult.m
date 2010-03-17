//
//  CoreResult.m
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import "CoreResult.h"


@implementation CoreResult

@synthesize source;
@synthesize resources;
@synthesize error;

- (id) initWithResources:(id)theResources {
    return [self initWithSource:nil andResources:theResources];
}

- (id) initWithSource:(id)theSource andResources:(id)theResources {
    if (self = [super init]) {
        self.source = theSource;
        self.resources = [theResources isKindOfClass:[NSArray class]] ? 
            theResources : [NSArray arrayWithObject:theResources];
    }
    NSLog(@"CoreResult: source: %@, theResources: %i, self.resources: %i", source, [theResources count], [self.resources count]);
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


- (void) dealloc {
    [source release];
    [resources release];
    [error release];
    [super dealloc];
}

@end
