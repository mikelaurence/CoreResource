//
//  CoreResult.m
//  CoreResource
//
//  Created by Mike Laurence on 12/31/09.
//  Copyright 2009 Mike Laurence. All rights reserved.
//

#import "CoreResult.h"
#import "CoreUtils.h"
#import "CoreManager.h"
#import "NSArray+Core.h"


@implementation CoreResult

@synthesize source;
@synthesize resources;
@synthesize error;
@synthesize faultContext;

- (id) initWithResources:(id)theResources {
    return [self initWithSource:nil andResources:theResources];
}

- (id) initWithSource:(id)theSource andResources:(id)theResources {
    if (self = [super init]) {
        source = [theSource retain];
        resources = [ToArray(theResources) retain];
    }
    //NSLog(@"CoreResult: source: %@, theResources: %i, self.resources: %i", source, [theResources count], [self.resources count]);
    return self;
}

- (id) initWithError:(NSError*)theError {
    if (self = [super init]) {
        error = [theError retain];
    }
    NSLog(@"CoreResult with error: %@", error);
    return self;
}

- (void) faultResourcesWithContext:(NSManagedObjectContext*)context {
    faultContext = [context retain];
    
    // Set resourceIds array and release resources; when the resources are next requested, they 
    // will be re-fetched from the fault context
    resourceIds = [[ToArray(resources) arrayMappedBySelector:@selector(objectID)] retain];
    [resources release];
    resources = nil;
}

- (CoreResource*) resource {
    return [self resources] != nil && [self resourceCount] > 0 ? [[self resources] objectAtIndex:0] : nil;
}

- (NSArray*) resources {
    if (resources == nil && resourceIds != nil && faultContext != nil) {
        resources = [[NSMutableArray arrayWithCapacity:[resourceIds count]] retain];
        for (NSManagedObjectID *objId in resourceIds)
            [(NSMutableArray*)resources addObject:[faultContext objectWithID:objId]];
    }
        
    return resources;
}

- (BOOL) hasAnyResources {
    return [self resourceCount] > 0;
}

- (int) resourceCount {
    return [self resources] != nil ? [[self resources] count] : 0;
}



#pragma mark -
#pragma mark Fast enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id*)stackbuf count:(NSUInteger)len {
    return [resources countByEnumeratingWithState:state objects:stackbuf count:len];
}



#pragma mark -
#pragma mark Lifecycle end

- (void) dealloc {
    [source release];
    [resources release];
    [resourceIds release];
    [error release];
    [super dealloc];
}

@end
