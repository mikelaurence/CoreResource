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

- (int) resultsCountForSection:(int)section;
- (CoreModel*) resourceAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*) noResultsMessageForSection:(int)section;

- (UITableViewCell*)tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*)tableView:(UITableView*)tableView noResultsCellForSection:(int)section;

@end

