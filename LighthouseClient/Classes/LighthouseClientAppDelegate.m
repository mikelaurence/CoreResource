//
//  LighthouseClientAppDelegate.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "LighthouseClientAppDelegate.h"


@implementation LighthouseClientAppDelegate

@synthesize coreManager;
@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Initialize Core Manager
    self.coreManager = [[[CoreManager alloc] init] autorelease];
    coreManager.logLevel = 1;
    coreManager.remoteSiteURL = @"http://coreresource.lighthouseapp.com";
    //coreManager.useBundleRequests = YES;
    
    // Environment-specific settings & actions
    /*
    if (PRODUCTION == 1) {
        NSLog(@"===== RUNNING IN PRODUCTION MODE =====");
    }
    else {
        coreManager.remoteSiteURL = @"http://localhost:4567";
        [Ticket findAll:nil andNotify:self withSelector:@selector(mockCompleted:)];
    }
    */
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

	return YES;
}

- (void) applicationWillTerminate:(UIApplication *)application {
    [coreManager save];
}



- (void)dealloc {
    [coreManager release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

