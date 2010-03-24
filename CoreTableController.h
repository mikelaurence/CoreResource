//
//  CoreTableController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Mike Laurence 2009. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "CoreResultsController.h"
#import "CoreResource.h"


@interface CoreTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>  {
	CoreResultsController *coreResultsController;
    
    NSTimer *tableReloadTimer;
    NSNumber *tableReloadDelay;
}

@property (nonatomic, retain) CoreResultsController *coreResultsController;

@property (nonatomic, retain) NSTimer *tableReloadTimer;
@property (nonatomic, retain) NSNumber *tableReloadDelay;

#pragma mark -
#pragma mark Results methods
- (Class) model;
- (int) resultsSectionCount;
- (BOOL) hasResults;
- (id) resultsInfoForSection:(int)section;
- (int) resultsCountForSection:(int)section;
- (CoreResource*) resourceAtIndexPath:(NSIndexPath*)indexPath;
- (NSString*) noResultsMessage;
- (BOOL) hasNoResultsMessage;

#pragma mark -
#pragma mark Table view methods
- (void) loadTableView;
- (UITableView*) tableView;
- (UITableViewCell*) tableView:(UITableView*)tableView resultCellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell*) noResultsCellForTableView:(UITableView*)tableView;

#pragma mark -
#pragma mark Core Results Controller
- (void) setSectionKeyPath:(NSString*)keyPath;
- (CoreResultsController*) coreResultsControllerWithSectionKeyPath:(NSString*)keyPath;

@end

#endif