//
//  EndGameScene.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-28.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "EndGameScene.h"
#import "MyScene.h"

@implementation EndGameScene

-(id)initWithSize:(CGSize)size{
    
    if(self = [super initWithSize:size]){
        //Stars
        SKSpriteNode * star = [SKSpriteNode spriteNodeWithImageNamed:@"star"];
        star.position = CGPointMake(25, self.size.height-30);
        [self addChild:star];
        SKLabelNode * lblStars = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblStars.fontSize = 30;
        lblStars.fontColor = [SKColor whiteColor];
        lblStars.position = CGPointMake(50, self.size.height -40);
        lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [self addChild:lblStars];
        
        //Score
        SKLabelNode * lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblScore.fontSize = 50;
        lblScore.fontColor = [SKColor whiteColor];
        lblScore.position = CGPointMake( 160  , 300);
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblScore setText:[NSString stringWithFormat:@"Score: %d", [GameState sharedInstance].score]];
        [self addChild:lblScore];
        
        //High Score
        SKLabelNode * lblHighScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblHighScore.fontSize = 30;
        lblHighScore.fontColor = [SKColor whiteColor];
        lblHighScore.position = CGPointMake(160, 150);
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblHighScore setText:[NSString stringWithFormat:@"highscore: %d", [GameState sharedInstance].highScore]];
        [self addChild:lblHighScore];
        
        //Try Again
        SKLabelNode * lblTryAgain = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTryAgain.fontSize = 30;
        lblTryAgain.fontColor = [SKColor whiteColor];
        lblTryAgain.position = CGPointMake(160, 50);
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTryAgain setText:@"Tap To Try Again"];
        [self addChild:lblTryAgain];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    SKScene * myScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition * reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:myScene transition:reveal];
}

@end
