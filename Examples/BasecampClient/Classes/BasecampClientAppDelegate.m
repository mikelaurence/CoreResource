//
//  BasecampClientAppDelegate.m
//  BasecampClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "BasecampClientAppDelegate.h"


@implementation BasecampClientAppDelegate

@synthesize coreManager;
@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Initialize Core Manager
    self.coreManager = [[[CoreManager alloc] init] autorelease];
    coreManager.logLevel = 1;
    coreManager.remoteSiteURL = @"http://coreresource.Basecampapp.com";
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    NSLog(@"Dict...");
    NSLog(@"DICT: %@", $D(@"Key", @"Value", @"Key", @"Value"));

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

