//
//  PingController.h
//  CorePingPlus
//
//  Created by Mike Laurence on 3/9/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PingController : UIViewController {
    UITextField *nameField;
    UITextView *messageField;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextView *messageField;

- (IBAction) submit;

@end
