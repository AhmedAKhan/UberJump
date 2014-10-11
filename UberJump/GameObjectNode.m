//
//  GameObjectNode.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "GameObjectNode.h"

@implementation GameObjectNode


-(BOOL)collisionWithPlayer:(SKNode *)player{
    return NO;
}

-(void)checkNodeRemoval:(CGFloat)playerY{
    if (playerY > self.position.y + 300.0f)
        [self removeFromParent];
}

@end
