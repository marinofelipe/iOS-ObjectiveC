//
//  FMHandlesToDoEntity.h
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoEntity.h"

@protocol FMHandlesToDoEntity <NSObject>

- (void) receiveToDoEntity:(ToDoEntity*)incomingToDoEntity;

@end
