//
//  LighthouseClientAppDelegate.h
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreManager.h"


@interface LighthouseClientAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    CoreManager *coreManager;
    
    UIWindow *window;
	UIViewController *mainViewController;
}

@property (nonatomic, retain) CoreManager *coreManager;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *mainViewController;

@end
