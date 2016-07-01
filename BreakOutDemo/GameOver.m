//
//  GameOver.m
//  BreakOutDemo
//
//  Created by Felipe Lefevre Marino on 5/21/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"

@implementation GameOver


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(touches) {
        SKView *skView = (SKView *) self.view;
        
        GameScene *gameScene = [GameScene nodeWithFileNamed:@"GameScene"];
        gameScene.scaleMode = SKSceneScaleModeAspectFit;
        
        [skView presentScene:gameScene];
    }
    
}

@end
