//
//  TicketsController.h
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTableController.h"


@interface TicketsController : CoreTableController <UISplitViewControllerDelegate> {
}

- (IBAction) refresh;

@end
