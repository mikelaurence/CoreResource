//
//  StatusesController.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright Mike Laurence 2010. All rights reserved.
//

#import "StatusesController.h"
#import "Status.h"
#import "DynamicCell.h"
#import "NSDate+Helper.h"
#import "CoreUtils.h"


@implementation StatusesController

- (Class) model { return [Status class]; }

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    // Send off remote find request
    [Status findAllRemote];

    // Activate local & remote fetch of statuses
    [[self coreResultsController] fetch:$D(
        @"createdAt DESC", @"$sort", 
        @"statusList", @"$template")];
}

- (UITableViewCell*)tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    // Get/create dynamic cell
    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"StatusCell"];
        cell.defaultFont = [UIFont systemFontOfSize:14.0];
    }

    // Get resource at index path
    Status *status = (Status*)[self resourceAtIndexPath:indexPath];

    // Customize cell
    [cell reset];
    [cell addLabelWithText:status.text];
    UILabel *dateLabel = [cell addLabelWithText:[status.createdAt stringDaysAgoAgainstMidnight:YES] andFont:[UIFont italicSystemFontOfSize:12.0]];
    dateLabel.textColor = [UIColor grayColor];
    [cell prepare];

    return cell;
}

@end

