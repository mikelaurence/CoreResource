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
static UIFont *boldFont;

- (void) viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}


#pragma mark -
#pragma mark Table View Methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell isKindOfClass:[DynamicCell class]] ? [(DynamicCell*)cell height] : 60.0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static float defaultFontSize = 15.0;
    if (boldFont == nil)
        boldFont = [[UIFont boldSystemFontOfSize:defaultFontSize] retain];

    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"TicketCell"];
        cell.defaultFont = [UIFont systemFontOfSize:defaultFontSize];
    }
    
    [cell reset];
    
    switch (indexPath.row) {
    case 0:
        // Title label
        [cell addLabelWithText:ticket.title andFont:[boldFont fontWithSize:defaultFontSize * 1.1]];
        break;
    case 1:
        // Priority label
        [cell addLabelWithText:@"Priority:"];
        UILabel *priorityLabel = [cell addLabelWithText:[ticket.priority stringValue] andFont:boldFont onNewLine:NO];
        priorityLabel.textColor = [UIColor orangeColor];
        break;
    case 2:
        // User labels
        [cell addLabelWithText:@"Created by:"];
        [cell addLabelWithText:ticket.creatorName andFont:boldFont onNewLine:NO];
        [cell addLabelWithText:@"Created at:"];
        [cell addLabelWithText:[dateFormatter stringFromDate:ticket.createdAt] andFont:boldFont onNewLine:NO];
        [cell addLabelWithText:@"Assigned to:"];
        [cell addLabelWithText:ticket.assignedUserName andFont:boldFont onNewLine:NO];
        break;
    case 3:
        // Body
        [cell addLabelWithText:@"Body:" andFont:boldFont];
        [cell addLabelWithText:ticket.latestBody andFont:[UIFont systemFontOfSize:defaultFontSize * 0.9]];
        break;
    }

    [cell prepare];
    return cell;
}



- (void) dealloc {
    [dateFormatter release];
    [ticket release];
    [super dealloc];
}

@end
