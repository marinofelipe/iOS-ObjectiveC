//
//  GameCenter.m
//  BreakOutDemo
//
//  Created by Felipe Lefevre Marino on 5/29/16.
//  Copyright © 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "GameCenter.h"
#import <GameKit/GameKit.h>

@implementation GameCenter


// Example on connecting to the game center on itunes
-(void)registerLocalPlayer {
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
    [player setAuthenticateHandler:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        if (viewController) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
}


//  Example of achievement, already registered in iTunes, being called
-(void)report10blockAchievement {
    
    //  The identifier have to be equal to the one on iTunes for this achievement
    GKAchievement *scoreAchievement = [[GKAchievement alloc] initWithIdentifier:@"Broke_10_Blocks"];
    scoreAchievement.percentComplete = 100;
    scoreAchievement.showsCompletionBanner = YES;
    
    //  report an array of achievements made by the player
    [GKAchievement reportAchievements:@[scoreAchievement] withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

//  Keep track os scores
-(void)reportScore: (int)myScore {
    
    //  The leaderboard identifier have to be equal on iTunes leaderboard for this gameCenter
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"High_Score"];
    score.value = myScore;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

//  Reset achievements
-(void)resetAchievements {
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}




@end
