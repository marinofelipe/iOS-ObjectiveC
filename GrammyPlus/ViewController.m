//
//  ViewController.m
//  GrammyPlus
//
//  Created by Delivery Resource on 21/01/16.
//  Copyright (c) 2016 Felipe Marino. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoutButton.enabled = NO;
    self.refreshButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Instagram"];
    self.loginButton.enabled = NO;
    self.logoutButton.enabled = YES;
    self.refreshButton.enabled = YES;
}

- (IBAction)logoutButtonPressed:(id)sender {
    NXOAuth2AccountStore* store = [NXOAuth2AccountStore sharedStore];
    NSArray* instagramAccounts = [store accountsWithAccountType:@"Instagram"];
    for (id acct in instagramAccounts)
        [store removeAccount:acct];
    self.loginButton.enabled = YES;
    self.logoutButton.enabled = NO;
    self.refreshButton.enabled = NO;

}

- (IBAction)refreshButtonPressed:(id)sender {
    NSArray* instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"Instagram"];
    if ([instagramAccounts count] == 0){
        NSLog(@"Warning: %ld instagram accouts logged in!", (long)[instagramAccounts count]);
        return;
    }
    NXOAuth2Account* acct = instagramAccounts[0];
    NSString* token = acct.accessToken.accessToken;
    
    NSString* urlStr = [@"https://api.instagram.com/v1/users/self/media/recent/?access_token=" stringByAppendingString:token];
    NSURL* url = [NSURL URLWithString:urlStr];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error){
        // check for network errors
        if (error) {
            NSLog(@"Error: Couldn't finish request: %@", error);
            return;
        }
        // check for http errors
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
        if (httpResp.statusCode < 200 || httpResp.statusCode >= 300) {
            NSLog(@"Error: Got status code %ld", (long)httpResp.statusCode);
            return;
        }
        
        // check for data/JSON parse errors
        NSError* parseError;
        id pkg = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!pkg) {
            NSLog(@"Couldn't parse response %@", parseError);
            return;
        }
        
        // access our data
        NSString *imageURLStr = pkg[@"data"][0][@"images"][@"standard_resolution"][@"url"];
        NSURL* imageURL = [NSURL URLWithString:imageURLStr];
        [[session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // check for network errors
            if (error) {
                NSLog(@"Error: Couldn't finish request: %@", error);
                return;
            }
            // check for http errors
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode < 200 || httpResp.statusCode >= 300) {
                NSLog(@"Error: Got status code %ld", (long)httpResp.statusCode);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData: data];
            });
        }] resume];
    }]resume];
}

@end
