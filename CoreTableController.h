//
//  CoreTableController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Mike Laurence 2009. All rights reserved.
//

#import "CoreResultsController.h"
#import "CoreModel.h"


@interface CoreTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>  {
	CoreResultsController *coreResultsController;
}

@property (nonatomic, retain) CoreResultsController *coreResultsController;

#pragma mark -
#pragma mark Date methods
- (Class) model;
- (int) resultsSectionCount;
- (BOOL) hasResults;
- (id) resultsInfoForSection:(int)section;
- (int) resultsCountForSection:(int)section;
- (CoreModel*) resourceAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*) noResultsMessage;
- (BOOL) hasNoResultsMessage;

#pragma mark -
#pragma mark Table view methods
- (UITableViewCell*) tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*) noResultsCellForTableView:(UITableView*)tableView;

@end
