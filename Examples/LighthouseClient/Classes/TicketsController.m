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


@implementation TicketsController

static float defaultFontSize = 15.0;

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// Use results controller to fetch local data. The table will automatically be reloaded if the underlying data changes
	// (e.g., via an influx of remote data.)
    [[self coreResultsController] fetch:$D(@"priority ASC", @"$sort", $B(FALSE), @"closed")];
	[[self tableView] reloadData];
}

- (IBAction) refresh {
    [Ticket findAllRemote];
}


#pragma mark -
#pragma mark Core table controller methods

- (Class) model {
	// Configure CoreTableController to use *Ticket* as its resource class
    return [Ticket class];
}


#pragma mark -
#pragma mark UITableView Data Source & Delegate

- (UITableViewCell*) tableView:(UITableView *)tableView resultCellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// Get resource at this index path
	Ticket *ticket = (Ticket*)[self resourceAtIndexPath:indexPath];

	// Dequeue or create DynamicCell
    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketsCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"TicketsCell"];
        cell.defaultFont = [UIFont systemFontOfSize:defaultFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Reset the DynamicCell (recycles all current views)
    [cell reset];

    // Add priority label
    UILabel* priorityLabel = [cell addLabelWithText:[ticket.priority stringValue] 
        andFont:[UIFont boldSystemFontOfSize:defaultFontSize * 3]];
    priorityLabel.textColor = [UIColor orangeColor];

    // Add title label
    [cell addLabelWithText:ticket.title andFont:[UIFont boldSystemFontOfSize:defaultFontSize] onNewLine:NO];
    
    // Add additional user labels
    UILabel *userLabel = [cell addLabelWithText:[NSString stringWithFormat:@"Assigned to %@", ticket.assignedUserName]];
    userLabel.textColor = [UIColor grayColor];

	// Prepare the DynamicCell (lays out all added subviews) and return
    [cell prepare];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.splitViewController)
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	// Get resource at this index path
	Ticket *ticket = (Ticket*)[self resourceAtIndexPath:indexPath];
	
	// Set up TicketController for viewing the details of an individual ticket
	TicketController *ticketController = nil;
	if (self.splitViewController)
		ticketController = [self.splitViewController.viewControllers objectAtIndex:1];
	else
		ticketController = [[[TicketController alloc] initWithNibName:nil bundle:nil] autorelease];
    ticketController.ticket = ticket;
    ticketController.title = [NSString stringWithFormat:@"Ticket #%@", ticket.number];
	
	// Show the controller (iPhone => navigation stack, iPad => update splitView's second view)
	if (self.splitViewController)
		[[ticketController tableView] reloadData];
	else
		[self.navigationController pushViewController:ticketController animated:YES];
}


#pragma mark -
#pragma mark UIViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}



@end
