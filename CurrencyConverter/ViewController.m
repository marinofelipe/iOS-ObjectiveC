//
//  ViewController.m
//  CurrencyConverter
//
//  Created by Felipe Lefevre Marino on 1/15/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyRequest/CRCurrencyRequest.h"
#import "CurrencyRequest/CRCurrencyResults.h"

@interface ViewController () <CRCurrencyRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *ConvertButton;
// obj to get the currency data
@property (nonatomic) CRCurrencyRequest *req;
//seg currency selec
@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *convertedValue;

@end

@implementation ViewController

- (IBAction)tappedButton:(id)sender {
    self.ConvertButton.enabled = NO;
    self.req = [[CRCurrencyRequest alloc]init];
    self.req.delegate = self;
    [self.req start];
}

- (void)currencyRequest:(CRCurrencyRequest *)req retrievedCurrencies:(CRCurrencyResults *)currencies {
    double inputValue = [self.inputField.text floatValue];
    double pesoValue = inputValue * currencies.MXN;
    double rupeesValue = inputValue * currencies.INR;
    double francsValue = inputValue * currencies.CHF;
    NSString *pesoString = [NSString stringWithFormat:@"%.2f", pesoValue];
    NSString *rupeesString = [NSString stringWithFormat:@"%.2f", rupeesValue];
    NSString *francsString = [NSString stringWithFormat:@"%.2f", francsValue];
    if (self.currencySegmentedControl.selectedSegmentIndex == 0) {
        self.convertedValue.text = pesoString;
    }
    else if (self.currencySegmentedControl.selectedSegmentIndex == 1) {
        self.convertedValue.text = rupeesString;
    }
    else {
        self.convertedValue.text = francsString;
    }
    self.ConvertButton.enabled = YES;
}


@end
