//
//  PlatformNode.h
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "GameObjectNode.h"

typedef NS_ENUM(int, PlatformType) {
    PLATFORM_NORMAL,
    PLATFORM_BREAKABLE,
};

@interface PlatformNode : GameObjectNode
{
    
}


@property PlatformType platformType;

@end
