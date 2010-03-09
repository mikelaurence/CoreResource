//
//  CorePingPlusAppDelegate.h
//  CorePing
//
//  Created by Mike Laurence on 3/8/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreManager.h"

@interface CorePingPlusAppDelegate : NSObject <UIApplicationDelegate> {
    CoreManager *coreManager;
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

