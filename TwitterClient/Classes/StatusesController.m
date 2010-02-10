//
//  StatusesController.m
//  TwitterClient
//
//  Created by Mike Laurence on 2/9/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "StatusesController.h"
#import "Status.h"
#import "DynamicCell.h"


@implementation StatusesController

- (Class) model { return [Status class]; }

- (void) viewDidLoad {
    [[self coreResultsController] fetch];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(DynamicCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath] height];
}

- (UITableViewCell*)tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    if (cell == nil)
        cell = [[DynamicCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"StatusCell"];

    // Get resource at index path
    Status *status = (Status*)[self resourceAtIndexPath:indexPath];

    // Customize cell
    [cell reset];
    [cell addTextViewWithText:status.text];

    return cell;
}

- (void)dealloc {
    [super dealloc];
}


@end

