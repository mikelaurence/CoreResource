//
//  CoreTableController.h
//  CoreResource
//
//  Created by Mike Laurence on 12/29/09.
//  Copyright Mike Laurence 2009. All rights reserved.
//

#import "CoreResultsController.h"

@interface CoreTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>  {
	CoreResultsController *coreResultsController;
}

@property (nonatomic, retain) CoreResultsController *coreResultsController;

@end

