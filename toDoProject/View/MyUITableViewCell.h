//
//  MyUITableViewCell.h
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity.h"

@interface MyUITableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *toDoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoDueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoPriorityLabel;
@property (strong, nonatomic) ToDoEntity* localToDoEntity;

- (void)setInternalFields:(ToDoEntity*)incomingToDoEntity;

@end
