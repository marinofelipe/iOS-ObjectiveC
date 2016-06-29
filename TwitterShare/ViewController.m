//
//  ViewController.m
//  TwitterShare
//
//  Created by Delivery Resource on 20/01/16.
//  Copyright (c) 2016 Felipe Marino. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UITextView *facebookTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreTextView;

- (void) configureTweetTextView;
- (void) configureFacebookTextView;
- (void) configureMoreTextView;
- (void) showAlertMessage:(NSString*) myMessage alertControllerWithTitle:(NSString*) viewTitle alertActionWithTitle:(NSString*) actionTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTweetTextView];
    [self configureFacebookTextView];
    [self configureMoreTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources tha`t can be recreated.
}

- (void)showAlertMessage:(NSString*) myMessage alertControllerWithTitle:(NSString*) viewTitle alertActionWithTitle:(NSString*) actionTitle {
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:viewTitle message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)twitterShare:(id)sender {
    if ([self.tweetTextView isFirstResponder] || [self.facebookTextView isFirstResponder] || [self.moreTextView isFirstResponder]) {
        [self.tweetTextView resignFirstResponder];
        [self.facebookTextView resignFirstResponder];
        [self.moreTextView resignFirstResponder];
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        // tweet out the tweet
        if ([self.tweetTextView.text length] < 140) {
            [twitterViewController setInitialText:self.tweetTextView.text];
        }
        else {
            NSString *shortText = [self.tweetTextView.text substringToIndex:140];
            [twitterViewController setInitialText:shortText];
        }
        
        [self presentViewController:twitterViewController animated:YES completion:nil];
    }
    else {
        // raise some kind of object
        [self showAlertMessage:@"You are not signed in to Twitter" alertControllerWithTitle:@"Twitter Share" alertActionWithTitle:@"OK"];
    }
}

- (IBAction)facebookShare:(id)sender {
    if ([self.tweetTextView isFirstResponder] || [self.facebookTextView isFirstResponder] || [self.moreTextView isFirstResponder]) {
        [self.tweetTextView resignFirstResponder];
        [self.facebookTextView resignFirstResponder];
        [self.moreTextView resignFirstResponder];
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookVC setInitialText:self.facebookTextView.text];
        // post on facebook
        [self presentViewController:facebookVC animated:YES completion:nil];
    }
    else {
        // raise the object cause its not signed in to facebook
        [self showAlertMessage:@"You are not signed in to Facebook" alertControllerWithTitle:@"Facebook Share" alertActionWithTitle:@"OK"];
    }
}

- (IBAction)showMore:(id)sender {
    if ([self.tweetTextView isFirstResponder] || [self.facebookTextView isFirstResponder] || [self.moreTextView isFirstResponder]) {
        [self.tweetTextView resignFirstResponder];
        [self.facebookTextView resignFirstResponder];
        [self.moreTextView resignFirstResponder];
    }
    UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.moreTextView.text] applicationActivities:nil];
    [self presentViewController:moreVC animated:YES completion:nil];
}

- (IBAction)emptyShare:(id)sender {
        [self showAlertMessage:@"This doesn't do anything" alertControllerWithTitle:@"Social Share" alertActionWithTitle:@"OK"];
}


- (void) configureTweetTextView {
    self.tweetTextView.layer.cornerRadius = 10.0;
    self.tweetTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.tweetTextView.layer.borderWidth = 2.0;
}

- (void) configureFacebookTextView {
    self.facebookTextView.layer.cornerRadius = 10.0;
    self.facebookTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.facebookTextView.layer.borderWidth = 2.0;
}

- (void) configureMoreTextView {
    self.moreTextView.layer.cornerRadius = 10.0;
    self.moreTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.moreTextView.layer.borderWidth = 2.0;
}

@end
