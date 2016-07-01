//
//  GameViewController.m
//  BreakOutDemo
//
//  Created by Felipe Lefevre Marino on 5/21/16.
//  Copyright (c) 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameStart.h"
#import <GameKit/GameKit.h>

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Configure game Center
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    [player setAuthenticateHandler:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        if (viewController) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
    
    
    

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    GameStart *startScene = [GameStart nodeWithFileNamed:@"GameStart"];
    startScene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [skView presentScene:startScene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
