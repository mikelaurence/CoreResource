//
//  TwitterClientAppDelegate.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "TwitterClientAppDelegate.h"


@implementation TwitterClientAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    	

    // Create & configure Core Manager
    coreManager = [[CoreManager alloc] init];
    coreManager.useBundleRequests = YES;
    coreManager.remoteSiteURL = @"twitter.com";
    coreManager.logLevel = 5;
    [coreManager retain];

    // Configure window
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [coreManager release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

