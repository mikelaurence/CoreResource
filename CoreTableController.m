//
//  CoreTableController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Punkbot LLC 2009. All rights reserved.
//

#import "CoreTableController.h"

@implementation CoreTableController;

@synthesize coreResultsController;


#pragma mark -
#pragma mark View lifecycle

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[coreResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[coreResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// In the simplest, most efficient, case, reload the table view.
	[(UITableView*)self.view reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[coreResultsController release];
    [super dealloc];
}


@end

