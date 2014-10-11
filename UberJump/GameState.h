//
//  GameState.h
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-28.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) int stars;

+(instancetype)sharedInstance;
-(void)saveState;

@end
