//
//  ViewController.m
//  Unit Converter
//
//  Created by Felipe Lefevre Marino on 1/19/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "ViewController.h"

double convertUnitOneToUnitTwo(double unitOneValue){
    double unitTwoValue;
    unitTwoValue = unitOneValue / 36;
    return unitTwoValue;
}

double convertUnitOneToUnitThree(double unitOneValue){
    double unitThreeValue;
    unitThreeValue = unitOneValue / 12;
    return unitThreeValue;
}

double convertUnitOneToUnitFour(double unitOneValue){
    double unitFourValue;
    unitFourValue = unitOneValue / 0.3937;
    return unitFourValue;
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Unitsegment;
@property (weak, nonatomic) IBOutlet UIButton *UpdateButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (IBAction)UpdateButtonTapped:(id)sender {
    NSMutableString *buf = [NSMutableString new];
    
    double userInput = [self.inputField.text doubleValue];
    
    if (self.Unitsegment.selectedSegmentIndex == 0) {
        double unitTwoValue = convertUnitOneToUnitTwo(userInput);
        [buf appendString:[@(unitTwoValue) stringValue]];
        buf = [NSMutableString stringWithFormat:@"%.2f",unitTwoValue];
    }
    else if (self.Unitsegment.selectedSegmentIndex == 1) {
        double unitThreeValue = convertUnitOneToUnitThree(userInput);
        buf = [NSMutableString stringWithFormat:@"%.2f",unitThreeValue];
    }
    else {
        double unitFourValue = convertUnitOneToUnitFour(userInput);
        buf = [NSMutableString stringWithFormat:@"%.2f",unitFourValue];
    }
    self.resultLabel.text = buf;
}

@end
