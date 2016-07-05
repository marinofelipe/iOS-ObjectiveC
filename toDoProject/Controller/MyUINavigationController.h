//
//  MyUINavigationController.h
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMHandlesMOC.h"

@interface MyUINavigationController : UINavigationController <FMHandlesMOC>

- (void) receiveMOC:(NSManagedObjectContext*)incomingMOC;

@end
