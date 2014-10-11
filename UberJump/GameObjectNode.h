//
//  GameObjectNode.h
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameObjectNode : SKNode{
    
}


-(BOOL)collisionWithPlayer:(SKNode *)player;
-(void)checkNodeRemoval:(CGFloat)playerY;

@end




/*// Called when a player physics body collides with the game object's physics body
 - (BOOL) collisionWithPlayer:(SKNode *)player;
 
 // Called every frame to see if the game object should be removed from the scene
 - (void) checkNodeRemoval:(CGFloat)playerY;*/