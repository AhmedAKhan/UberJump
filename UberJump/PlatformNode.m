//
//  PlatformNode.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "PlatformNode.h"

@implementation PlatformNode

-(BOOL)collisionWithPlayer:(SKNode *)player{
    
    if(player.physicsBody.velocity.dy < 0){
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 250);
        
        if(_platformType == PLATFORM_BREAKABLE)
            [self removeFromParent];
    
    }
    
    return NO;
}

@end
