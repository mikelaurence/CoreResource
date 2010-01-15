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
@synthesize coreManager;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    self.coreManager = [[CoreManager alloc] init];
    NSLog(@"Created Core Manager");

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
    
    [super applicationDidFinishLaunching:application];
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

