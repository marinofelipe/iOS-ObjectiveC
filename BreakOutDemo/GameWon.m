//
//  GameWon.m
//  BreakOutDemo
//
//  Created by Felipe Lefevre Marino on 5/27/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "GameWon.h"
#import "GameScene.h"

@implementation GameWon


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches) {
        
        SKView * view = (SKView *)self.view;
        [self removeFromParent];
        
        //  create and configure the scene
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        //  present the game scene
        [view presentScene:scene];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
