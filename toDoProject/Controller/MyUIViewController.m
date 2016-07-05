//
//  MyUIViewController.m
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import "MyUIViewController.h"

@interface MyUIViewController ()

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) ToDoEntity* localToDoEntity;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsField;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDateField;
@property (weak, nonatomic) IBOutlet UISwitch *dueDatePrioritySwitch;

@property (nonatomic, assign) BOOL wasDeleted;

@property (nonatomic, assign) BOOL highPriority;

@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) receiveMOC:(NSManagedObjectContext*)incomingMOC {
    self.managedObjectContext = incomingMOC;
}

- (void) receiveToDoEntity:(ToDoEntity*)incomingToDoEntity {
    self.localToDoEntity = incomingToDoEntity;
}

- (void) viewWillAppear:(BOOL)animated {
    
    //  SetUp Delete State
    self.wasDeleted = NO;
    
    //  setUp Form
    self.titleField.text = self.localToDoEntity.toDoTitle;
    self.detailsField.text = self.localToDoEntity.toDoDetails;
    
    BOOL priority = [self.localToDoEntity.toDoPriority boolValue];
    if (priority == YES) {
        self.dueDatePrioritySwitch.on = YES;
        self.highPriority = YES;
    }
    else {
        self.dueDatePrioritySwitch.on = NO;
        self.highPriority = NO;
    }
    
    NSDate* dueDate = self.localToDoEntity.toDoDueDate;
    if (dueDate != nil) {
        [self.dueDateField setDate:dueDate];
    }
    
    //  detect edit ended
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self
     ];}    

- (IBAction)titleFieldEdited:(id)sender {
    self.localToDoEntity.toDoTitle = self.titleField.text;
    [self saveMyToDoEntity];
}

- (void) saveMyToDoEntity {
    NSError* error;
    BOOL saveSuccess = [self.managedObjectContext save:&error];
    if (!saveSuccess) {
        @throw [NSException exceptionWithName:NSGenericException reason:@"Couldn't save" userInfo:@{NSUnderlyingErrorKey:error}];
    }
}

- (IBAction)dueDateEdited:(id)sender {
    self.localToDoEntity.toDoDueDate = self.dueDateField.date;
    [self saveMyToDoEntity];
}

- (IBAction)trashTapped:(id)sender {
    [self.managedObjectContext deleteObject:self.localToDoEntity];
    [self saveMyToDoEntity];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.wasDeleted = YES;
}

- (void) textViewDidEndEditing:(NSNotification*)notification {
    if ([notification object] == self) {
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        [self saveMyToDoEntity];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    if (self.wasDeleted == NO) {
        self.localToDoEntity.toDoTitle = self.titleField.text;
        self.localToDoEntity.toDoDetails = self.detailsField.text;
        self.localToDoEntity.toDoDueDate = self.dueDateField.date;
        
        
        NSNumber* num = [NSNumber numberWithBool:self.dueDatePrioritySwitch.on];
        
        if (self.dueDatePrioritySwitch.on == NO) {
            self.highPriority = NO;
            self.localToDoEntity.toDoPriority = num;
        }
        else {
            self.highPriority = NO;
            self.localToDoEntity.toDoPriority = num;
        }
        
        //[self saveMyToDoEntity];
    }
    
    //  remove detection
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UITextViewTextDidEndEditingNotification object:self
    ];
}

@end
