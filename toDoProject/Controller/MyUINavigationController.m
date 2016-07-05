//
//  MyUINavigationController.m
//  toDoProject
//
//  Created by Delivery Resource on 11/02/16.
//  Copyright © 2016 Felipe Marino. All rights reserved.
//

#import "MyUINavigationController.h"

@interface MyUINavigationController ()

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation MyUINavigationController

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
    id<FMHandlesMOC> child = (id<FMHandlesMOC>) self.viewControllers[0];
    [child receiveMOC:self.managedObjectContext];
}

@end
