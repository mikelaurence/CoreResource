//
//  TwitterClientAppDelegate.h
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright 2010 Mike Laurence. All rights reserved.
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

