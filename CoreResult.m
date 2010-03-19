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
@synthesize context;

- (id) initWithResources:(id)theResources {
    return [self initWithSource:nil andResources:theResources];
}

- (id) initWithSource:(id)theSource andResources:(id)theResources {
    if (self = [super init]) {
        self.source = theSource;
        if (YES)
            resourceIds = [[ToArray(theResources) arrayMappedBySelector:@selector(objectID)] retain];
        else
            self.resources = theResources;
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
    return [self resources] != nil && [self resourceCount] > 0 ? [[self resources] objectAtIndex:0] : nil;
}

- (NSArray*) resources {
    if (resources == nil && resourceIds != nil) {
        self.resources = [NSMutableArray arrayWithCapacity:[resourceIds count]];
        for (NSManagedObjectID *objId in resourceIds)
            [(NSMutableArray*)resources addObject:[[self context] objectWithID:objId]];
    }
        
    return resources;
}

- (BOOL) hasAnyResources {
    return [self resourceCount] > 0;
}

- (int) resourceCount {
    return [self resources] != nil ? [[self resources] count] : 0;
}

- (NSManagedObjectContext*) context {
    if (context == nil)
        self.context = [[CoreManager main] managedObjectContext];
    return context;
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
