//
//  StarNode.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "StarNode.h"
@import AVFoundation;

@interface StarNode(){
    SKAction * _starSound;
}

@end

@implementation StarNode

-(BOOL)collisionWithPlayer:(SKNode *)player{
    
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 400.0f);
    [self.parent runAction:_starSound];
    [self removeFromParent];
    
    [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20:100);
    [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1:5);
    
    
    return YES;
}

-(id)init{
    if(self = [super init]){
        _starSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
    }
    
    return self;
}

@end
