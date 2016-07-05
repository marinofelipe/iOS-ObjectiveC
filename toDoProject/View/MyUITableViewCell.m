//
//  MyUITableViewCell.m
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import "MyUITableViewCell.h"

@implementation MyUITableViewCell

- (void)setInternalFields:(ToDoEntity*)incomingToDoEntity {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.toDoTitleLabel.text = incomingToDoEntity.toDoTitle;
    self.localToDoEntity = incomingToDoEntity;
    
    if (incomingToDoEntity.toDoPriority.boolValue == YES) {
        self.toDoPriorityLabel.text = @"High";
        self.toDoPriorityLabel.textColor = [UIColor redColor];
    }
    else {
        self.toDoPriorityLabel.text = @"";
    }
    
    self.toDoDueDateLabel.text = [dateFormatter stringFromDate: incomingToDoEntity.toDoDueDate];
}

@end
