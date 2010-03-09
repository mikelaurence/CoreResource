//
//  PingsController.m
//  CorePing
//
//  Created by Mike Laurence on 3/8/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "PingsController.h"
#import "Ping.h"
#import "DynamicCell.h"
#import "NSDate+Helper.h"
#import "PingController.h"


@implementation PingsController


#pragma mark -
#pragma mark View lifecycle

- (void) loadView { [self loadTableView]; }

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
    [[self coreResultsController] fetchWithSort:@"created_at DESC"];
}


#pragma mark -
#pragma mark Actions

- (IBAction) refresh {
    [Ping findAllRemote];
}

- (IBAction) compose {
    [self presentModalViewController:[[[PingController alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
}


#pragma mark -
#pragma mark Table view methods

- (UITableViewCell*) tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {

    Ping *ping = (Ping*)[self resourceAtIndexPath:indexPath];

    DynamicCell* cell = (DynamicCell*) [tableView dequeueReusableCellWithIdentifier:@"PingCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"PingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.defaultFont = [UIFont systemFontOfSize:15.0];
    }
    
    [cell reset];
    [cell addLabelWithText:ping.name andFont:[UIFont boldSystemFontOfSize:19.0]];
    [cell addLabelWithText:ping.message];
    UILabel *createdAtLabel = [cell addLabelWithText:[ping.created_at stringDaysAgo]];
    createdAtLabel.textColor = [UIColor grayColor];
    [cell prepare];
    
    return cell;
}


@end

