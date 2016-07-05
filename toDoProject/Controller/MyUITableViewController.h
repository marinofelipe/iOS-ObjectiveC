//
//  MyUITableViewController.h
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMHandlesMOC.h"
#import "FMHandlesToDoEntity.h"

@interface MyUITableViewController : UITableViewController <FMHandlesMOC, FMHandlesToDoEntity>

- (void) receiveMOC:(NSManagedObjectContext*)incomingMOC;

@end
