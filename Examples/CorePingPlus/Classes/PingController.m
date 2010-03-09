//
//  PingController.m
//  CorePingPlus
//
//  Created by Mike Laurence on 3/9/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "PingController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreManager.h"
#import "ASIFormDataRequest.h"


@implementation PingController

@synthesize nameField, messageField;

- (void) viewDidLoad {
    messageField.layer.cornerRadius = 5.0;
    messageField.layer.borderWidth = 1.0;
}

- (void) viewWillAppear:(BOOL)animated {
    [nameField becomeFirstResponder];
}

- (IBAction) submit {
    // Simple ASI form request until CoreResource#create methods are done
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://coreresource.org/pings"]];
    [request setPostValue:(nameField.text != nil && [nameField.text length] > 0 ? nameField.text : @"Anonymous Coward") forKey:@"name"];
    [request setPostValue:messageField.text forKey:@"message"];
    [request setPostValue:[[UIDevice currentDevice] model] forKey:@"device"];
    [[CoreManager main] enqueueRequest:request];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
