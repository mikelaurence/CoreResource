//
//  CoreManager.m
//  CoreManager
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "CoreManager.h"

#if TARGET_OS_IPHONE
#import "Reachability.h"
#endif

@implementation CoreManager

@synthesize persistentStoreCoordinator, managedObjectContext, managedObjectModel;
@synthesize requestQueue, deserialzationQueue;
@synthesize remoteSiteURL, useBundleRequests, bundleRequestDelay, defaultDateParser;
@synthesize entityDescriptions, modelProperties, modelRelationships, modelAttributes;
@synthesize logLevel;

#pragma mark -
#pragma mark Static access

static CoreManager* _main;
+ (CoreManager*) main { return _main; }
+ (void) setMain:(CoreManager*) newMain { _main = newMain; }

#pragma mark -
#pragma mark Configuration

- (id) init {
    return [self initWithOptions:nil];
}

- (id) initWithOptions:(NSDictionary*)options {
    if (self = [super init]) {
        if (_main == nil)
            _main = self;
        requestQueue = [[NSOperationQueue alloc] init];
        deserialzationQueue = [[NSOperationQueue alloc] init];
        
        // Default date parser is ruby DateTime.to_s style parser
        defaultDateParser = [[NSDateFormatter alloc] init];
        [defaultDateParser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        self.entityDescriptions = [NSMutableDictionary dictionary];
        self.modelProperties = [NSMutableDictionary dictionary];
        self.modelRelationships = [NSMutableDictionary dictionary];
        
        useBundleRequests = NO;
        bundleRequestDelay = 0;
        
        logLevel = 1;
        
        // ===== Core Data initialization ===== //
        
        // Create primary managed object model
        managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
        
        // Create persistent store coordinator
        NSString *dbName = [options objectForKey:@"dbName"];
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] 
            stringByAppendingPathComponent: dbName != nil ? dbName : @"coreresource.sqlite"]];
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            NSLog(@"Unresolved error in persistent store creation %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Create primary managed object context
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];        
    }
    return self;
}


#pragma mark -
#pragma mark Networking

- (void) enqueueRequest:(ASIHTTPRequest*)request {
    if ([CoreManager main].logLevel > 2);
        NSLog(@"[CoreManager#enqueueRequest] request queued: %@", request.url);
    [requestQueue addOperation:request];
}


#pragma mark -
# pragma mark Alerts

+ (void) alertWithError:(NSError*)error {
    [self alertWithTitle:@"Error" andMessage:[error localizedDescription]];
}

#if TARGET_OS_IPHONE
+ (void) alertWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
        message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#endif

+ (void) logCoreDataError:(NSError *)error {
    NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
    NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
    if(detailedErrors != nil && [detailedErrors count] > 0) {
        for(NSError* detailedError in detailedErrors)
                NSLog(@"  DetailedError: %@", [detailedError userInfo]);
    }
    else
        NSLog(@"  %@", [error userInfo]);
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

- (NSManagedObjectContext*)newContext {
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    return [context autorelease];
}


- (void) mergeContext:(NSNotification*)notification {
    NSAssert([NSThread mainThread], @"Must be on the main thread!");
    [managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    //NSLog(@"\n\nMerged context, now has contents:\n\n %@ \n\n", [[Artist findAllLocal] resources]);
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
    // If this is the global "main" manager, nullify it
    if (self == _main)
        _main = nil;

    [modelProperties release];
    [modelRelationships release];

    [remoteSiteURL release];

    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];

    [super dealloc];
}


@end

