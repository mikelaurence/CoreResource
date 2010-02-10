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

- (void) viewDidLoad {
    // Activate local & remote fetch of statuses
    [[self coreResultsController].fetchRequest setSortDescriptors:[CoreUtils sortDescriptorsFromString:@"createdAt DESC"]];
    [[self coreResultsController] fetch];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Simply return DynamicCell's computed height
    return [(DynamicCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath] height];
}

- (UITableViewCell*)tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    // Get/create dynamic cell
    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"StatusCell"];
        cell.defaultFont = [UIFont systemFontOfSize:14.0];
    }

    // Get resource at index path
    Status *status = (Status*)[self resourceAtIndexPath:indexPath];

    // Customize cell
    [cell reset];
    [cell addLabelWithText:status.text];
    UILabel *dateLabel = [cell addLabelWithText:[status.createdAt stringDaysAgoAgainstMidnight:YES] andFont:[UIFont italicSystemFontOfSize:12.0]];
    dateLabel.textColor = [UIColor grayColor];

    return cell;
}

- (void)dealloc {
    [super dealloc];
}


@end

