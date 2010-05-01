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
static float defaultFontSize = 15.0;

- (void) viewDidLoad {
    [super viewDidLoad];

	/*
	if (self.splitViewController) {
		CGRect frame = self.view.frame;
		frame.size.width = self.splitViewController.view.bounds.size.width - 
			((UIViewController*)[self.splitViewController.viewControllers objectAtIndex:0]).view.bounds.size.width;
		self.view.frame = frame;
	}
	*/
    
	dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
}


#pragma mark -
#pragma mark Table View Data Source & Delegate

- (UITableView*) tableView {
	return (UITableView*) self.view;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ticket ? 4 : 1;
}

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    DynamicCell* cell = (DynamicCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [[cell height] floatValue];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Default fonts
    if (boldFont == nil)
        boldFont = [[UIFont boldSystemFontOfSize:defaultFontSize] retain];

    // Get existing or create Dynamic Cell
    DynamicCell *cell = (DynamicCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketCell"];
    if (cell == nil) {
        cell = [DynamicCell cellWithReuseIdentifier:@"TicketCell"];
		if (self.splitViewController)
			cell.frame = CGRectMake(0, 0, 1024 - 320, 44); // Hack to get splitView cells the proper width
        cell.defaultFont = [UIFont systemFontOfSize:defaultFontSize];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [cell reset];
    
	if (ticket) {
		
		// Add different UI elements based on cell row
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
	}
	else {
		[cell setPadding:50.0];
		UILabel *label = [cell addLabelWithText:@"No ticket selected." andFont:[UIFont boldSystemFontOfSize:40.0]];
		label.textColor = [UIColor lightGrayColor];
	}

    [cell prepare];
    return cell;
}


#pragma mark -
#pragma mark UISplitViewControllerDelegate

//the master view controller will be hidden
- (void)splitViewController:(UISplitViewController*)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem
	   forPopoverController:(UIPopoverController*)pc {
	
	// Create toolbar with "show tickets" button
	if (toolbar == nil) {
		barButtonItem.title = @"Tickets";
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
		[toolbar setItems:[NSArray arrayWithObject:barButtonItem] animated:YES];
	}
	
	// Add the toolbar to ticket detail view
	[self.splitViewController.view addSubview:toolbar];
	
	// Add inset to top of table view so the toolbar doesn't overlap rows
	[self tableView].contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

- (void)splitViewController:(UISplitViewController*)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)button {

	// Remove toolbar
	[toolbar removeFromSuperview];
	
	// Remove inset
	[self tableView].contentInset = UIEdgeInsetsZero;
}



#pragma mark -
#pragma mark UIViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}



#pragma mark -
#pragma mark Lifecycle end

- (void) dealloc {
	[toolbar release];
    [dateFormatter release];
    [ticket release];
    [super dealloc];
}

@end
