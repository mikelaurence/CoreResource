//
//  PingsController.m
//  CorePing
//
//  Created by Mike Laurence on 3/8/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "PingsController.h"
#import "Ping.h"


@implementation PingsController


#pragma mark -
#pragma mark View lifecycle

- (void) viewWillAppear:(BOOL)animated {
    [Ping findAllRemote];
    [[self coreResultsController] fetchWithSort:@"created_at DESC"];
}


@end

