//
//  TicketsController.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "TicketsController.h"
#import "Ticket.h"
#import "DynamicCell.h"


@implementation TicketsController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Ticket findAll];
}


#pragma mark -
#pragma mark Core table controller methods

- (Class) model {
    return [Ticket class];
}


#pragma mark -
#pragma mark Table View Methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell isKindOfClass:[DynamicCell class]] ? [(DynamicCell*)cell height] : 60.0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView resultCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static float defaultFontSize = 17.0;

    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"DynamicCell"];
    }
    
    Ticket *ticket = (Ticket*)[self resourceAtIndexPath:indexPath];
    
    [cell reset];
    [cell addLabelWithText:ticket.title andFont:[UIFont boldSystemFontOfSize:defaultFontSize]];
    [cell prepare];
    return cell;
}


@end
