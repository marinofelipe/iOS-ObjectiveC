//
//  ToDoEntity+CoreDataProperties.h
//  toDoProject
//
//  Created by Delivery Resource on 16/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDoEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDoEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *toDoDetails;
@property (nullable, nonatomic, retain) NSDate *toDoDueDate;
@property (nullable, nonatomic, retain) NSString *toDoTitle;
@property (nullable, nonatomic, retain) NSNumber *toDoPriority;

@end

NS_ASSUME_NONNULL_END
