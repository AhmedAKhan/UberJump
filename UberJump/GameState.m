//
//  GameState.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-28.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "GameState.h"

@implementation GameState

-(id)init{
    
    if(self = [super init]){
        _score = 0;
        _highScore = 0;
        _stars = 0;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id highscore = [defaults objectForKey:@"highScore"];
        if(highscore){
            _highScore = [highscore integerValue];
        }
        id stars = [defaults objectForKey:@"stars"];
        if (stars) {
            _stars = [stars integerValue];
        }
    }
    return self;
}

-(void)saveState{
    _highScore = MAX(_score, _highScore);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
    [defaults setObject:[NSNumber numberWithInt:_stars] forKey:@"stars"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(instancetype)sharedInstance{
    static dispatch_once_t pred = 0;
    static GameState * _sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        _sharedInstance = [[super alloc] init];
    });
    return _sharedInstance;
}

@end
