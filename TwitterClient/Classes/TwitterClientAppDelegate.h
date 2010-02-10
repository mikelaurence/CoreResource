//
//  TwitterClientAppDelegate.h
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreManager.h"

@interface TwitterClientAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    
    CoreManager *coreManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

