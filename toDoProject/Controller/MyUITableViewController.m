//
//  MyUITableViewController.m
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MyUITableViewController.h"
#import "ToDoEntity.h"
#import "MyUITableViewCell.h"

@interface MyUITableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController* resultsController;


@end

@implementation MyUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeNSFetchedResultsControllerDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsController.sections[section].numberOfObjects;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoEntity* item = self.resultsController.sections[indexPath.section].objects[indexPath.row];
    MyUITableViewCell* cell = (MyUITableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier" forIndexPath:indexPath];
    [cell setInternalFields:item];
    return cell;
}

    
#pragma mark NSFetchedResultsControllerDelegate

- (void) initializeNSFetchedResultsControllerDelegate {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoDueDate" ascending:YES]];
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.resultsController.delegate = self;
    
    NSError* error;
    BOOL fetchSucceeded = [self.resultsController performFetch:&error];
    if (!fetchSucceeded) {
        @throw [[NSException alloc] initWithName:NSInternalInconsistencyException reason:@"Couldn't fetch" userInfo:nil];
    }
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            MyUITableViewCell* cell = [self.tableView   cellForRowAtIndexPath:indexPath];
            ToDoEntity* item = [controller objectAtIndexPath:indexPath];
            [cell setInternalFields:item];
            break;
        }
        case NSFetchedResultsChangeMove:
            [[self tableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id<FMHandlesMOC, FMHandlesToDoEntity> child = (id<FMHandlesMOC, FMHandlesToDoEntity>)[segue destinationViewController];
    [child receiveMOC:self.managedObjectContext];
    
    ToDoEntity* item;
    if ([sender isMemberOfClass:[UIBarButtonItem class]]) {
        
        item = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:self.managedObjectContext];
    }
    else {
        MyUITableViewCell* source = (MyUITableViewCell*) sender;
        item = source.localToDoEntity;
    }
    [child receiveToDoEntity:item];
}

- (void) receiveMOC:(NSManagedObjectContext*)incomingMOC {
    self.managedObjectContext = incomingMOC;
}



@end
