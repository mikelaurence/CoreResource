//
//  CoreDeserializer.m
//  Core Resource
//
//  Created by Mike Laurence on 3/11/10.
//  Copyright 2010 Mike Laurence.
//

#import "CoreDeserializer.h"
#import "CoreResult.h"


@implementation CoreDeserializer

@synthesize resourceClass, json, target, action;

- (void) main {
    coreManager = [resourceClass performSelector:@selector(coreManager)];

    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:[coreManager persistentStoreCoordinator]];
    [[NSNotificationCenter defaultCenter] addObserver:self 
        selector:@selector(contextDidSave:) 
        name:NSManagedObjectContextDidSaveNotification 
        object:managedObjectContext];
        
    NSArray* resources = [resourceClass performSelector:@selector(deserializeFromString:) withObject:json];
    
    NSError *error = nil;
    [managedObjectContext save:&error];
        
    // Remove observation of context save
    [[NSNotificationCenter defaultCenter] removeObserver:self 
        name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
        
    if (target && action && [target respondsToSelector:action]) {
        CoreResult *result = error != nil ?
            [[CoreResult alloc] initWithResources:resources] :
            [[CoreResult alloc] initWithError:error];
        [target performSelector:action withObject:result];
        [result release];
    }
}

- (void)contextDidSave:(NSNotification*)notification {
    [coreManager performSelectorOnMainThread:@selector(mergeContext:) 
        withObject:notification 
        waitUntilDone:NO];
}

@end
