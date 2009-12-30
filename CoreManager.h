//
//  CoreResource.h
//  CoreResource
//
//  Created by Mike Laurence on 12/24/09.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

@interface CoreManager : NSObject {    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSOperationQueue *requestQueue;
    
    NSString *remoteSiteURL;
    NSDateFormatter *defaultDateParser;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSOperationQueue *requestQueue;

@property (nonatomic, retain) NSString *remoteSiteURL;
@property (nonatomic, retain) NSDateFormatter *defaultDateParser;

+ (CoreManager*) main;
+ (void) setMain: (CoreManager*)newMain;

- (NSString *)applicationDocumentsDirectory;


#pragma mark -
#pragma mark Networking
+ (BOOL) checkReachability: (BOOL) showConnectionError;


#pragma mark -
#pragma mark Alerts
+ (void) alertWithError:(NSError*)error;
+ (void) alertWithTitle:(NSString*)title andMessage:(NSString*)message;

@end

