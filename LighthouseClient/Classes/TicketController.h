//
//  TicketController.h
//  LighthouseClient
//
//  Created by Mike Laurence on 3/6/10.
//  Copyright 2010 Punkbot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"


@interface TicketController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    Ticket *ticket;
}

@property (nonatomic, retain) Ticket *ticket;

@end
