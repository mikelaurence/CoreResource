//
//  CoreTestAppDelegate.m
//  CoreTest
//
//  Created by Mike Laurence on 1/14/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "CoreTestAppDelegate.h"


@implementation CoreTestAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
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

