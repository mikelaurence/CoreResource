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
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSOperationQueue *requestQueue;

@property (nonatomic, retain) NSString *remoteSiteURL;

+ (CoreManager*) main;
+ (void) setMain: (CoreManager*)newMain;

- (NSString *) getRemoteSite;
- (void) setRemoteSite: (NSString*)siteURL;

- (NSString *)applicationDocumentsDirectory;

@end

