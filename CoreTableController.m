//
//  CoreTableController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Mike Laurence 2009. All rights reserved.
//

#import "CoreTableController.h"


@implementation CoreTableController;

@synthesize coreResultsController;


- (Class) model { return nil; }

#pragma mark -
#pragma mark Data methods

- (int) resultsCountForSection:(int)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self coreResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (CoreModel*) resourceAtIndexPath:(NSIndexPath*)indexPath {
    return (CoreModel*)[[self coreResultsController] objectAtIndexPath:indexPath];
}

- (NSString*) noResultsMessageForSection:(int)section {
    return @"No results found.";
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int sections = [[[self coreResultsController] sections] count];
    return sections > 0 ? sections : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int ct = [self resultsCountForSection:section];
    return ct > 0 ? ct : ([self noResultsMessageForSection:section] != nil ? 1 : 0);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[[self coreResultsController] sections] objectAtIndex:indexPath.section];
    if ([sectionInfo numberOfObjects] > 0)
        return [self tableView:tableView resultCellForRowAtIndexPath:indexPath];
    else
        return [self tableView:tableView noResultsCellForSection:indexPath.section];
}

- (UITableViewCell*)tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
    
    CoreModel *resource = [self resourceAtIndexPath:indexPath];
    cell.textLabel.text = [resource performSelector:
        ([resource respondsToSelector:@selector(title)] ? @selector(title) :
            ([resource respondsToSelector:@selector(name)] ? @selector(name) : @selector(description)))];
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView noResultsCellForSection:(int)section {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoResultsCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoResultsCell"];
        cell.textLabel.text = [self noResultsMessageForSection:section];
        cell.textLabel.font = [UIFont systemFontOfSize:22.0];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {

	// In the simplest, most efficient, case, reload the table view.
	[(UITableView*)self.view reloadData];
}


- (CoreResultsController*) coreResultsController {
    if (coreResultsController == nil) {
        self.coreResultsController = [[CoreResultsController alloc] 
            initWithFetchRequest:[[self model] fetchRequestWithDefaultSort]
            managedObjectContext:[[self model] managedObjectContext] 
            sectionNameKeyPath:nil 
            cacheName:nil];
        coreResultsController.entityClass = [self model];
        coreResultsController.delegate = self;
    }
    return coreResultsController;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[coreResultsController release];
    [super dealloc];
}


@end

