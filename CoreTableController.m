//
//  CoreTableController.m
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Mike Laurence 2009. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "CoreTableController.h"
#import "NSString+InflectionSupport.h"


@implementation CoreTableController;

@synthesize coreResultsController;
@synthesize tableReloadTimer, tableReloadDelay;

static float defaultTableReloadDelay = 0.25;


#pragma mark -
#pragma mark Data methods

- (Class) model { 
    return NSClassFromString(
        [[NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""] singularize]);
}

- (int) resultsSectionCount {
    return [[[self coreResultsController] sections] count];
}

- (BOOL) hasResults {
    return [self resultsSectionCount] > 0 && [self resultsCountForSection:0] > 0;
}

- (id) resultsInfoForSection:(int)section {
    return [[[self coreResultsController] sections] objectAtIndex:section];
}

- (int) resultsCountForSection:(int)section {
    if (section < [self resultsSectionCount])
        return [[self resultsInfoForSection:section] numberOfObjects];
    return 1;
}

- (CoreResource*) resourceAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section < [self resultsSectionCount])
        return (CoreResource*)[[self coreResultsController] objectAtIndexPath:indexPath];
    return nil;
}

- (NSString*) noResultsMessage {
    return @"No results found.";
}

- (BOOL) hasNoResultsMessage {
    return [self noResultsMessage] != nil;
}



#pragma mark -
#pragma mark Table view methods

- (void) loadTableView {
    UITableView* tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.view = tableView;
}

- (UITableView*) tableView {
    return (UITableView*)self.view;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self hasResults] ? [self resultsSectionCount] : 
        ([self hasNoResultsMessage] ? 1 : 0);
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self hasResults] ? [self resultsCountForSection:section] : 1;
}

- (CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell respondsToSelector:@selector(height)] ? 
        [[cell performSelector:@selector(height)] floatValue] : 
        tableView.rowHeight;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self hasResults])
        return [self tableView:tableView resultCellForRowAtIndexPath:indexPath];
    else
        return [self noResultsCellForTableView:tableView];
}

- (UITableViewCell*) tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"] autorelease];
    
    CoreResource *resource = [self resourceAtIndexPath:indexPath];
    cell.textLabel.text = [resource performSelector:
        ([resource respondsToSelector:@selector(title)] ? @selector(title) :
            ([resource respondsToSelector:@selector(name)] ? @selector(name) : @selector(description)))];
    
    return cell;
}

- (UITableViewCell*) noResultsCellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NoResultsCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoResultsCell"] autorelease];
        cell.textLabel.text = [self noResultsMessage];
        cell.textLabel.font = [UIFont systemFontOfSize:22.0];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}



#pragma mark -
#pragma mark FetchedResultsController delegate methods

// Notifies the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {

    // Invalidate any existing table reload timer
    [tableReloadTimer invalidate];
    
	// Set table reload delay to default if undefined
    if (tableReloadDelay == nil)
        self.tableReloadDelay = $F(defaultTableReloadDelay);
    
    // Begin a new timer to reload table data after tableReloadDelay
    self.tableReloadTimer = [NSTimer scheduledTimerWithTimeInterval:[tableReloadDelay doubleValue] 
        target:[self tableView] selector:@selector(reloadData) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark Core Results Controller

- (void) setSectionKeyPath:(NSString*)keyPath {
    if (coreResultsController != nil) {
        // Cancel if the key path isn't changing
        if ([coreResultsController.sectionNameKeyPath isEqualToString:keyPath])
            return;
            
        [coreResultsController release];
    }
    self.coreResultsController = [self coreResultsControllerWithSectionKeyPath:keyPath];
}

- (CoreResultsController*) coreResultsController {
    if (coreResultsController == nil)
        self.coreResultsController = [self coreResultsControllerWithSectionKeyPath:nil];
    return coreResultsController;
}

- (CoreResultsController*) coreResultsControllerWithSectionKeyPath:(NSString*)keyPath {
    CoreResultsController* controller = [[[CoreResultsController alloc] 
        initWithFetchRequest:[[self model] fetchRequestWithDefaultSort]
        managedObjectContext:[[self model] managedObjectContext] 
        sectionNameKeyPath:keyPath
        cacheName:nil] autorelease];
    controller.entityClass = [self model];
    controller.delegate = self;
    return controller;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[coreResultsController release];
    [super dealloc];
}

@end

#endif

