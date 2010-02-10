//
//  TwitterClientAppDelegate.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "TwitterClientAppDelegate.h"
#import "RootViewController.h"


@implementation TwitterClientAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
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
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

