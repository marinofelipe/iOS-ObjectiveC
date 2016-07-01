//
//  GameScene.m
//  BreakOutDemo
//
//  Created by Felipe Lefevre Marino on 5/21/16.
//  Copyright (c) 2016 Felipe Lefevre Marino. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
#import "GameWon.h"
#import <GameKit/GameKit.h>


static const CGFloat kTrackPointsPerSecond = 1000;

static const uint32_t category_fence = 0x1 << 3; //0x00000000000000000000000000001000
static const uint32_t category_paddle = 0x1 << 2; //0x00000000000000000000000000000100
static const uint32_t category_block = 0x1 << 1; //0x00000000000000000000000000000010
static const uint32_t category_ball = 0x1 << 0; //0x00000000000000000000000000000001

static const int kBottomZPosition = 0;
static const int kPlayingZPosition = 1;
static const int kEffectsZPosition = 2;


@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, strong, nullable) UITouch *motivatingTouch;
@property (strong, nonatomic) NSMutableArray *blockFrames;
@property (assign, nonatomic) int bustedBlocks;
@property (assign, nonatomic) BOOL busted1Block;
@property (assign, nonatomic) BOOL busted10Blocks;


@end


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    //  Achievements
    self.bustedBlocks = 0;
    self.busted1Block = NO;
    self.busted10Blocks = NO;
    [self resetAchievements];
    
    
    [self createPhysicsBody];
    
    SKSpriteNode *background = (SKSpriteNode *)[self childNodeWithName:@"background"];
    background.zPosition = kBottomZPosition;
    background.lightingBitMask = 0x1;
    
    
    SKSpriteNode* ball1 = [self createAndAddBallsWithXCoordinate:60 yCoordinate:30 xVelocity:200.0 andYvelocity:200.0];
    ball1.name = @"ball1";
    ball1.zPosition = kPlayingZPosition;
    
    SKSpriteNode* ball2 = [self createAndAddBallsWithXCoordinate:60 yCoordinate:75 xVelocity:0.0 andYvelocity:0.0];
    ball2.name = @"ball2";
    ball2.zPosition = kPlayingZPosition;
    
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);
    
    SKPhysicsJointSpring *joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody bodyB:ball2.physicsBody anchorA:ball1Anchor anchorB:ball2Anchor];
    
    joint.damping = 0.0;
    joint.frequency = 1.5;
    
    [self.scene.physicsWorld addJoint:joint];
    
    
    SKSpriteNode *paddle = [self createAndAddPaddle];
    paddle.name = @"paddle";
    paddle.zPosition = kPlayingZPosition;
    paddle.lightingBitMask = 0x1;
    
    
    
    //  Adding blocks animations
    self.blockFrames = [NSMutableArray array];
    
    SKTextureAtlas *blockAnimation = [SKTextureAtlas atlasNamed:@"block.atlas"];
    unsigned long numImages = blockAnimation.textureNames.count;
    
    for (int i=0; i<numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"block%02d", i];
        SKTexture *temp = [blockAnimation textureNamed:textureName];
        [self.blockFrames addObject:temp];
    }
    
    
    
    //  Adding blocks
    [self createAndAddBlocks];
    
    
    
    
    //  Adding ball light
    SKLightNode *light = [SKLightNode new];
    light.categoryBitMask = 0x1;
    light.falloff = 1;
    light.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light.zPosition = kPlayingZPosition;
    
    [ball1 addChild:light];
    
    SKLightNode *light2 = [SKLightNode new];
    light2.categoryBitMask = 0x1;
    light2.falloff = 1;
    light2.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light2.lightColor = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    light2.lightColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light2.zPosition = kPlayingZPosition;
    
    [ball2 addChild:light2];
    

}

#pragma mark - Update - Each Frame
-(void)update:(CFTimeInterval)currentTime {
    static const float kMaxSpeed = 1500.0f;
    static const float kMinSpeed = 400.0f;
    
    //  Adjust the linear damping if the ball starts moving a little too fast or slow
    SKNode *ball1 = [self childNodeWithName:@"ball1"];
    SKNode *ball2 = [self childNodeWithName:@"ball2"];
    
    float speedBall1 = sqrtf(ball1.physicsBody.velocity.dx * ball1.physicsBody.velocity.dx + ball1.physicsBody.velocity.dy * ball1.physicsBody.velocity.dy);
    
    float dx = (ball1.physicsBody.velocity.dx + ball2.physicsBody.velocity.dx)/2;
    float dy = (ball1.physicsBody.velocity.dy + ball2.physicsBody.velocity.dy)/2;
    float speed = sqrt(dx*dx+dy*dy);
    
    if (speedBall1 > kMaxSpeed || speed > kMaxSpeed) {
        ball1.physicsBody.linearDamping += 0.1f;
        ball2.physicsBody.linearDamping += 0.1f;
    }
    else if (speedBall1 < kMinSpeed || speed < kMinSpeed) {
        ball1.physicsBody.linearDamping -= 0.1f;
        ball2.physicsBody.linearDamping -= 0.1f;
    }
    
    else {
        ball1.physicsBody.linearDamping = 0.1f;
        ball2.physicsBody.linearDamping = 0.1f;
    }
}


#pragma mark - Scene Physics Body
-(void)createPhysicsBody {
    self.name = @"fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    self.physicsWorld.contactDelegate = self;
}


#pragma mark - Touches callbacks

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    const CGRect touchRegion = CGRectMake(0, 0, self.size.width, self.size.height * 0.3);
    
    for(UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        
        if(CGRectContainsPoint(touchRegion, p)) {
            self.motivatingTouch = touch;
        }
    }
    
    [self trackPaddlesToMotivatingTouches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self trackPaddlesToMotivatingTouches];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch]) {
        self.motivatingTouch = nil;
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([touches containsObject:self.motivatingTouch]) {
        self.motivatingTouch = nil;
    }
}


#pragma mark - Create balls
-(SKSpriteNode *)createAndAddBallsWithXCoordinate:(int) xCoordinate yCoordinate:(int) yCoordinate xVelocity:(double) xVelocity andYvelocity:(double) yVelocity {
    
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width/2];
    ball.physicsBody.dynamic = YES;
    ball.position = CGPointMake(xCoordinate, yCoordinate);
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.angularDamping = 0.0;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.mass = 1.0;
    ball.physicsBody.velocity = CGVectorMake(xVelocity, yVelocity);    //initial velocity
    ball.physicsBody.affectedByGravity = NO;
    ball.physicsBody.categoryBitMask = category_ball;
    ball.physicsBody.collisionBitMask = category_fence | category_block | category_paddle | category_ball;
    ball.physicsBody.contactTestBitMask = category_fence | category_block;
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    
    [self addChild:ball];
    
    return ball;
}



#pragma mark - Create Paddle
-(SKSpriteNode *)createAndAddPaddle {
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
    paddle.physicsBody.dynamic = NO;
    paddle.position = CGPointMake(self.size.width/2, 100);
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 1.0;
    paddle.physicsBody.velocity = CGVectorMake(0.0, 0.0);    //initial velocity
    paddle.physicsBody.affectedByGravity = NO;
    paddle.physicsBody.categoryBitMask = category_paddle;
    paddle.physicsBody.collisionBitMask = 0x0;
    paddle.physicsBody.contactTestBitMask = category_ball;
    paddle.physicsBody.usesPreciseCollisionDetection = YES;

    
    [self addChild:paddle];
    
    return paddle;
}


#pragma mark - Create Blocks
-(void)createAndAddBlocks {
    
    ///*
    // Constructing rows of blocks - A new method to create them will be better - Make it!
    
    //Add blocks
    SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
    block.xScale = 0.7;
    block.yScale = 0.7;
    
    CGFloat kBlockWidth = block.size.width;
    CGFloat kBlockHeight = block.size.height;
    CGFloat kBlockHorizonSpace = 20.0f;
    int kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizonSpace));
    
    // Adding top row of blocks
    for(int i=0; i<kBlocksPerRow; i++) {
        SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        block.xScale = 0.7;
        block.yScale = 0.7;
//        SKSpriteNode *block = [SKSpriteNode spriteNodeWithImageNamed:@"redBlock"];
        block.name = @"block";
        block.position = CGPointMake(kBlockHorizonSpace/2 + kBlockWidth/2 + i*(kBlockWidth)+i*kBlockHorizonSpace, self.size.height - 100);
        block.zPosition = kPlayingZPosition;
        block.lightingBitMask = 0x1;
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO;
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0);    //initial velocity
        block.physicsBody.affectedByGravity = NO;
        block.physicsBody.categoryBitMask = category_block;
        block.physicsBody.collisionBitMask = 0x0;
        block.physicsBody.contactTestBitMask = category_ball;
        
        [self addChild:block];
    }
    
    //  Middle row of blocks
    kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizonSpace)) - 1;
    
    for(int i=0; i<kBlocksPerRow; i++) {
        SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        block.xScale = 0.7;
        block.yScale = 0.7;
        block.name = @"block";
        block.position = CGPointMake(kBlockHorizonSpace + kBlockWidth + i*(kBlockWidth)+i*kBlockHorizonSpace, self.size.height - 100 - 1.5 * kBlockHeight);
        block.zPosition = kPlayingZPosition;
        block.lightingBitMask = 0x1;
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO;
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0);    //initial velocity
        block.physicsBody.affectedByGravity = NO;
        block.physicsBody.categoryBitMask = category_block;
        block.physicsBody.collisionBitMask = 0x0;
        block.physicsBody.contactTestBitMask = category_ball;
        
        [self addChild:block];
    }
    
    //  Third row of blocks
    kBlocksPerRow = (self.size.width / (kBlockWidth + kBlockHorizonSpace));
    
    for(int i=0; i<kBlocksPerRow; i++) {
        SKSpriteNode *block = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        block.xScale = 0.7;
        block.yScale = 0.7;
        block.name = @"block";
        block.position = CGPointMake(kBlockHorizonSpace/2 + kBlockWidth/2 + i*(kBlockWidth)+i*kBlockHorizonSpace, self.size.height - 100 - 3.0 * kBlockHeight);
        block.zPosition = kPlayingZPosition;
        block.lightingBitMask = 0x1;
        block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:block.size center:CGPointMake(0, 0)];
        block.physicsBody.dynamic = NO;
        block.physicsBody.friction = 0.0;
        block.physicsBody.restitution = 1.0;
        block.physicsBody.linearDamping = 0.0;
        block.physicsBody.angularDamping = 0.0;
        block.physicsBody.allowsRotation = NO;
        block.physicsBody.mass = 1.0;
        block.physicsBody.velocity = CGVectorMake(0.0, 0.0);    //initial velocity
        block.physicsBody.affectedByGravity = NO;
        block.physicsBody.categoryBitMask = category_block;
        block.physicsBody.collisionBitMask = 0x0;
        block.physicsBody.contactTestBitMask = category_ball;
        
        [self addChild:block];
    }

}


#pragma mark - Tracking Paddles
-(void)trackPaddlesToMotivatingTouches {
    SKNode *node = [self childNodeWithName:@"paddle"];
    
    UITouch *touch = self.motivatingTouch;
    if(!touch) {
        return;
    }
    
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos - node.position.x) / kTrackPointsPerSecond;
    [node runAction:[SKAction moveToX:xPos duration:duration]];
}


#pragma mark - SKPhysicsContactDelegateMethods
-(void)didBeginContact:(SKPhysicsContact *)contact {
    NSString *nameA = contact.bodyA.node.name;
    NSString *nameB = contact.bodyB.node.name;
    
    if(([nameA containsString:@"block"] && [nameB containsString:@"ball"]) || ([nameA containsString:@"ball"] && [nameB containsString:@"block"])) {
        
        
        //  Handling Achievements
        self.bustedBlocks++;
        
        if ((self.bustedBlocks >= 1) && (self.busted1Block == NO)) {
            self.busted1Block = YES;
            [self report1BlockAchievement];
        }
        if ((self.bustedBlocks >= 10) && (self.busted10Blocks == NO)) {
            self.busted10Blocks = YES;
            [self report10BlocksAchievement];
        }
        
        
        
        //  Figure out wich body is exploding
        SKNode *block;
        if ([nameA containsString:@"block"]) {
            block = contact.bodyA.node;
        }
        else {
            block = contact.bodyB.node;
        }
        
        
        //  Do the ramp build up
        SKAction *actionAudioRamp = [SKAction playSoundFileNamed:@"firstHit.m4a" waitForCompletion:NO];
        SKAction *actionVisualRamp = [SKAction animateWithTextures:self.blockFrames timePerFrame:0.04f resize:NO restore:NO];
        
        
        NSString *particleRampUpPath = [[NSBundle mainBundle] pathForResource:@"ParticleRampUp" ofType:@"sks"];
        SKEmitterNode *particleRamp = [NSKeyedUnarchiver unarchiveObjectWithFile:particleRampUpPath];
        particleRamp.position = CGPointMake(0, 0);
        particleRamp.zPosition = kBottomZPosition;
        
        SKAction *actionParticleRamp = [SKAction runBlock:^{
            [block addChild:particleRamp];
        }];
        
        
        //  Ramp group
        SKAction *actionRampGroup = [SKAction group:@[actionAudioRamp, actionParticleRamp, actionVisualRamp]];
        
        
        
        //  Explosion buid up
        SKAction *actionAudioExplosion = [SKAction playSoundFileNamed:@"explosion.m4a" waitForCompletion:NO];
        
        NSString *particleExplosionPath = [[NSBundle mainBundle] pathForResource:@"ParticleExplosion" ofType:@"sks"];
        SKEmitterNode *particleExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplosionPath];
        particleExplosion.position = CGPointMake(0, 0);
        particleExplosion.zPosition = kEffectsZPosition;
        
        SKAction *actionParticleExplosion = [SKAction runBlock:^{
            [block addChild:particleExplosion];
        }];
        
        
        //  Score Particle build up
        NSString *particleScorePath = [[NSBundle mainBundle] pathForResource:@"ParticleScore" ofType:@"sks"];
        SKEmitterNode *particleScore = [NSKeyedUnarchiver unarchiveObjectWithFile:particleScorePath];
        particleScore.position = CGPointMake(0, 0);
        particleScore.zPosition = kEffectsZPosition;
        
        SKAction *actionParticleScore = [SKAction runBlock:^{
            [block addChild:particleScore];
        }];
        
        
        //  Remove block action
        SKAction *actionRemoveBlock = [SKAction removeFromParent];
        
        
        // Explosion sequence
        SKAction *actionExplosionSequence = [SKAction sequence:@[actionAudioExplosion, actionParticleExplosion, [SKAction fadeOutWithDuration:1]]];
        
        
        //  Check game won condition
        SKAction *checkGameWon = [SKAction runBlock:^{
            BOOL anyBlocksRemaining = ([self childNodeWithName:@"block"] != nil);
            if (!anyBlocksRemaining) {
                SKView *skView = (SKView *)self.view;
                [self removeFromParent];
                
                
                //  Reporting Final Score
                [self reportScore:(self.bustedBlocks*100)];
                
                
                GameWon *scene = [GameWon nodeWithFileNamed:@"GameWon"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                [skView presentScene:scene];
            }
        }];
        
        
        
        // Run all actions to change blocks
        [block runAction:[SKAction sequence:@[actionParticleScore, actionRampGroup, actionExplosionSequence, actionRemoveBlock, checkGameWon]]];

    }
    
    else if (([nameA containsString:@"paddle"] && [nameB containsString:@"ball"]) || ([nameB containsString:@"paddle"] && [nameA containsString:@"ball"])) {
        
        SKAction *paddleAudio = [SKAction playSoundFileNamed:@"paddle.m4a" waitForCompletion:NO];
        [self runAction:paddleAudio];
    }
    else {
        if(([nameA containsString:@"fence"] && [nameB containsString:@"ball"]) || ([nameA containsString:@"ball"] && [nameB containsString:@"fence"])) {
            
            
            //  Figure out wich body is the ball
            SKNode *ball;
            if ([nameA containsString:@"ball"]) {
                ball = contact.bodyA.node;
            }
            else {
                ball = contact.bodyB.node;
            }
            
            
            /* You missed the ball - Game Over */
            if (contact.contactPoint.y < 10) {
                
                //  Explosion buid up
                SKAction *actionAudioExplosion = [SKAction playSoundFileNamed:@"explosion.m4a" waitForCompletion:NO];
                
                NSString *particleExplosionPath = [[NSBundle mainBundle] pathForResource:@"ParticleExplosion" ofType:@"sks"];
                SKEmitterNode *particleExplosion = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplosionPath];
                particleExplosion.position = CGPointMake(0, 0);
                particleExplosion.zPosition = kEffectsZPosition;
                
                SKAction *actionParticleExplosion = [SKAction runBlock:^{
                    [ball addChild:particleExplosion];
                }];
                
                
                //  Remove ball action
                SKAction *removeBall = [SKAction removeFromParent];
                
                
                
                //  Report Score
                SKAction *reportScore = [SKAction runBlock:^{
                    [self reportScore:(self.bustedBlocks*100)];
                }];

                
                //  Switch Scene action
                SKAction *switchToGameOver = [SKAction runBlock:^{
                        SKView *skView = (SKView *)self.view;
                        [self removeFromParent];
                        
                        GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
                        scene.scaleMode = SKSceneScaleModeAspectFit;
                        [skView presentScene:scene];
                }];
                
                SKAction *ballExplodeSequence = [SKAction sequence:@[actionAudioExplosion, actionParticleExplosion, [SKAction fadeOutWithDuration:0.25], removeBall, reportScore, switchToGameOver]];
                
                [ball runAction:ballExplodeSequence];
                
            }
            else {
                SKAction *fenceAudio = [SKAction playSoundFileNamed:@"wall.m4a" waitForCompletion:NO];
                [self runAction:fenceAudio];
            }
        }
//        else {
//            SKAction *explode = [SKAction playSoundFileNamed:@"explosion.m4a" waitForCompletion:NO];
//            [self runAction:explode];
        //}
    }
}



#pragma mark - Achievements Methods

//  Reset achievements
-(void)resetAchievements {
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


//  reporting 1Block Achievement
-(void)report1BlockAchievement {
    
    //  The identifier have to be equal to the one on iTunes for this achievement
    GKAchievement *scoreAchievement = [[GKAchievement alloc] initWithIdentifier:@"Broke_1_Block"];
    scoreAchievement.percentComplete = 100;
    scoreAchievement.showsCompletionBanner = YES;
    
    //  report an array of achievements made by the player
    [GKAchievement reportAchievements:@[scoreAchievement] withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

//  reporting 1Blocks Achievement
-(void)report10BlocksAchievement {
    
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


@end































