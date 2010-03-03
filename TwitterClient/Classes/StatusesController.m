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
    [[self coreResultsController] fetch:[NSDictionary dictionaryWithObjectsAndKeys:
        @"createdAt DESC", @"$sort", 
        @"statusList", @"$template",
        nil]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell isKindOfClass:[DynamicCell class]] ? [(DynamicCell*)cell height] : 60.0;
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

- (void)dealloc {
    [super dealloc];
}


@end

