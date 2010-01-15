//
//  CoreManager.m
//  CoreManager
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreManager.h"
#import "Reachability.h"

@implementation CoreManager

@synthesize requestQueue;
@synthesize remoteSiteURL, useBundleRequests, bundleRequestDelay, defaultDateParser;
@synthesize modelPropertyTypes, modelRelationships;

#pragma mark -
#pragma mark Static access

static CoreManager* _main;
+ (CoreManager*) main { return _main; }
+ (void) setMain:(CoreManager*) newMain { _main = newMain; }

#pragma mark -
#pragma mark Configuration

- (id) init {
    if (self = [super init]) {
        [CoreManager setMain:self];
        self.requestQueue = [[NSOperationQueue alloc] init];
        
        // Default date parser is ruby DateTime.to_s style parser
        self.defaultDateParser = [[NSDateFormatter alloc] init];
        [defaultDateParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        //[defaultDateParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
        
        self.modelPropertyTypes = [NSMutableDictionary dictionary];
        self.modelRelationships = [NSMutableDictionary dictionary];
        
        useBundleRequests = NO;
        bundleRequestDelay = 0;
    }
    return self;
}


#pragma mark -
#pragma mark Networking

+ (BOOL) checkReachability: (BOOL) showConnectionError {
    // Check if the remote server is available
    Reachability *reachManager = [Reachability sharedReachability];
    [reachManager setHostName: @"api.meetup.com"];
    NetworkStatus remoteHostStatus = [reachManager remoteHostStatus];
    if (remoteHostStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if (showConnectionError)
            [self alertWithTitle:@"Network Error" 
                andMessage:@"Oops - cannot reach the server! Please ensure you have Internet connectivity and try again."];
        
        return NO;
    }
    return YES;
}

- (void) enqueueRequest:(ASIHTTPRequest*)request {
    NSLog(@"[CoreManager#enqueueRequest] request queued: %@", request.url);
    [requestQueue addOperation:request];
}


# pragma mark Alerts

+ (void) alertWithError:(NSError*)error {
    [self alertWithTitle:@"Error" andMessage:[error localizedDescription]];
}

+ (void) alertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
        message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (void) logCoreDataError:(NSError *)error {
    NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                    NSLog(@"  DetailedError: %@", [detailedError userInfo]);
            }
    }
    else {
            NSLog(@"  %@", [error userInfo]);
    }
}




#pragma mark -
#pragma mark Core Data stack


/**

 */
- (void)save {
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			[[self class] logCoreDataError:error];
        } 
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WaitsOnIphone.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [modelPropertyTypes release];
    [modelRelationships release];

    [remoteSiteURL release];

    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];

    [super dealloc];
}


@end

