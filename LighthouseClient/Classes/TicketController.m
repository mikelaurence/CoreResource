//
//  TicketController.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import "TicketController.h"
#import "DynamicCell.h"


@implementation TicketController

@synthesize ticket;


#pragma mark -
#pragma mark Table View Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell isKindOfClass:[DynamicCell class]] ? [(DynamicCell*)cell height] : 60.0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static float defaultFontSize = 15.0;

    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"TicketCell"];
        cell.defaultFont = [UIFont systemFontOfSize:defaultFontSize];
    }
    
    [cell reset];

    // Priority label
    UILabel* priorityLabel = [cell addLabelWithText:[ticket.priority stringValue] 
        andFont:[UIFont boldSystemFontOfSize:defaultFontSize * 3]];
    priorityLabel.textColor = [UIColor orangeColor];

    // Title label
    [cell addLabelWithText:ticket.title andFont:[UIFont boldSystemFontOfSize:defaultFontSize] onNewLine:NO];

    [cell prepare];
    return cell;
}



- (void) dealloc {
    [ticket release];
    [super dealloc];
}

@end
