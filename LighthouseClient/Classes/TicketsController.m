//
//  TicketsController.m
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright Punkbot LLC 2010. All rights reserved.
//

#import "TicketsController.h"
#import "TicketController.h"
#import "DynamicCell.h"
#import "CoreUtils.h"


@implementation TicketsController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Ticket findAll];
    [[self coreResultsController] fetch:[NSDictionary dictionaryWithObject:@"priority ASC" forKey:@"$sort"]];
}

- (IBAction) refresh {
    [Ticket findAllRemote];
}


#pragma mark -
#pragma mark Core table controller methods

- (Class) model {
    return [Ticket class];
}


#pragma mark -
#pragma mark Table View Methods

- (UITableViewCell*) tableView:(UITableView *)tableView resultCellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static float defaultFontSize = 15.0;

    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketsCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"TicketsCell"];
        cell.defaultFont = [UIFont systemFontOfSize:defaultFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Ticket *ticket = (Ticket*)[self resourceAtIndexPath:indexPath];
    
    [cell reset];

    // Priority label
    UILabel* priorityLabel = [cell addLabelWithText:[ticket.priority stringValue] 
        andFont:[UIFont boldSystemFontOfSize:defaultFontSize * 3]];
    priorityLabel.textColor = [UIColor orangeColor];

    // Title label
    [cell addLabelWithText:ticket.title andFont:[UIFont boldSystemFontOfSize:defaultFontSize] onNewLine:NO];
    
    // User labels
    UILabel *userLabel = [cell addLabelWithText:[NSString stringWithFormat:@"Assigned to %@", ticket.assignedUserName]];
    userLabel.textColor = [UIColor grayColor];

    [cell prepare];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TicketController *ticketController = [[[TicketController alloc] initWithNibName:nil bundle:nil] autorelease];
    Ticket *ticket = (Ticket*)[self resourceAtIndexPath:indexPath];
    ticketController.ticket = ticket;
    ticketController.title = [NSString stringWithFormat:@"Ticket #%@", ticket.number];
    [self.navigationController pushViewController:ticketController animated:YES];
}


@end
