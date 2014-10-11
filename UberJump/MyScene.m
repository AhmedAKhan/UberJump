//
//  MyScene.m
//  UberJump
//
//  Created by Ahmed Arif Khan on 2014-05-27.
//  Copyright (c) 2014 Ahmed Khan. All rights reserved.
//

#import "MyScene.h"
#import "StarNode.h"
#import "PlatformNode.h"
#import "EndGameScene.h"
@import CoreMotion;

#pragma mark - Custom Definitions

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer     = 0x1 << 0,
    CollisionCategoryStar       = 0x1 << 1,
    CollisionCategoryPlatform   = 0x1 << 2,
};

@interface MyScene() <SKPhysicsContactDelegate> {
    SKNode * _backgroundNode;
    SKNode * _midgroundNode;
    SKNode * _foregroundNode;
    SKNode * _hudNode;
    SKNode * _player;
    SKNode * _tapToStart;
    int _endLevelY;//the amount of points needed to pass the level
    CMMotionManager *_motionManager;// Motion manager for accelerometer
    CGFloat _xAcceleration;// Acceleration value from accelerometer
    SKLabelNode * _lblScore;
    SKLabelNode * _lblStars;
    int _maxPlayerY;
    BOOL _gameOver;
}


@end

@implementation MyScene

#pragma mark - Creating The Scene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        self.physicsWorld.contactDelegate = self;
        [GameState sharedInstance].score = 0;
        _maxPlayerY = 80;
        _gameOver = NO;
        
        _backgroundNode = [self creatingBackgroundNode];
        [self addChild:_backgroundNode];
        
        _midgroundNode = [self createMidgroundNode];
        [self addChild:_midgroundNode];
        
        _foregroundNode = [SKNode node];
        [self addChild:_foregroundNode];
        
        _hudNode = [SKSpriteNode node];
        [self addChild:_hudNode];
        
        NSString * levelPlist = [[NSBundle mainBundle] pathForResource:@"Level01" ofType:@"plist"];
        NSDictionary * levelData = [NSDictionary dictionaryWithContentsOfFile:levelPlist];
        
        _endLevelY = [levelData[@"EndY"] intValue];
        
        NSDictionary * platforms = levelData[@"Platforms"];
        NSDictionary * platformPatterns = platforms[@"Patterns"];
        NSArray * platfromPositions = platforms[@"Positions"];
        for (NSDictionary * platformPosition in platfromPositions){
            CGFloat patternX = [platformPosition[@"x"] floatValue];
            CGFloat patternY = [platformPosition[@"y"] floatValue];
            NSString * pattern = platformPosition[@"pattern"];
            
            NSArray * platformPattern = platformPatterns[pattern];
            for (NSDictionary * platformPoint in platformPattern){
                CGFloat x = [platformPoint[@"x"] floatValue];
                CGFloat y = [platformPoint[@"y"] floatValue];
                PlatformType type = [platformPoint[@"type"] integerValue];
                
                PlatformNode * platform = [self createPlatformAtPosition:CGPointMake(x + patternX, y + patternY) ofType:type];
                [_foregroundNode addChild:platform];
            }
           
        }
        
        NSDictionary * stars = levelData[@"Stars"];
        //represents the position of the star relative to the positiong of the pattern
        NSDictionary * starPatterns = stars[@"Patterns"];
        NSArray * patternPositionsArray = stars[@"Positions"]; //represent the position of the pattern
        for (NSDictionary * patternPosition in patternPositionsArray){
            //the location of the pattern
            CGFloat patternX = [patternPosition[@"x"] floatValue];
            CGFloat patternY = [patternPosition[@"y"] floatValue];
            NSString * pattern = patternPosition[@"pattern"];
            
            NSArray * starPositions = starPatterns[pattern];
            for (NSDictionary * starPosition in starPositions){
                CGFloat x = [starPosition[@"x"] floatValue];
                CGFloat y = [starPosition[@"y"] floatValue];
                StarType type = [starPosition[@"type"] intValue];
                
                StarNode * star = [self createStarAtPosition:CGPointMake(x + patternX, y + patternY) ofType:type];
                [_foregroundNode addChild:star];
            }
            
        }
        
        _player = [self createPlayer];
        [_foregroundNode addChild:_player];
        
        _tapToStart = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
        _tapToStart.position = CGPointMake(160, 180.0f);
        [self addChild:_tapToStart];
        
        
        [self setupTheHUD];
        
        
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.2;
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * accelerometerData, NSError *error){
            CMAcceleration acceleration = accelerometerData.acceleration;
            _xAcceleration = (acceleration.x * 0.75) + (_xAcceleration * 0.25);
        }];
    }
    return self;
}

-(void)setupTheHUD{
    //make the star label and star
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"star"];
    star.position = CGPointMake(25, self.size.height - 30);
    [_hudNode addChild:star];
    
    _lblStars = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _lblStars.fontSize = 30;
    _lblStars.fontColor = [SKColor whiteColor];
    _lblStars.position = CGPointMake(50, self.size.height - 40);
    _lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    [_lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
    [_hudNode addChild:_lblStars];
    
    //make the score label
    _lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _lblScore.fontSize = 30;
    _lblScore.fontColor = [SKColor whiteColor];
    _lblScore.position = CGPointMake(self.size.width -20, self.size.height-40);
    _lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    
    [_lblScore setText:@"0"];
    [_hudNode addChild:_lblScore];
}

-(PlatformNode *)createPlatformAtPosition:(CGPoint)position ofType:(PlatformType)type{
    
    PlatformNode * node = [PlatformNode node];
    [node setPosition:position];
    [node setName:@"NODE_PLATFORM"];
    [node setPlatformType:type];
    
    SKSpriteNode *sprite;
    if(type == PLATFORM_BREAKABLE)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"PlatformBreak"];
    else
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Platform"];
    [node addChild:sprite];
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = CollisionCategoryPlatform;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

-(SKNode *)createPlayer{
    SKNode * playerNode = [SKNode node];
    [playerNode setPosition:CGPointMake(160.0f, 80.0f)];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    [playerNode addChild:sprite];
    
    playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    playerNode.physicsBody.dynamic = NO;//we will change this later
    playerNode.physicsBody.allowsRotation = NO;
    
    playerNode.physicsBody.restitution = 1.0f;
    playerNode.physicsBody.friction = 0.0f;
    playerNode.physicsBody.angularDamping = 0.0f;
    playerNode.physicsBody.linearDamping = 0.0f;
    
    playerNode.physicsBody.usesPreciseCollisionDetection = YES;
    playerNode.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    playerNode.physicsBody.collisionBitMask = 0;
    playerNode.physicsBody.contactTestBitMask = CollisionCategoryStar | CollisionCategoryPlatform;
    
    return  playerNode;
}


-(SKNode *)creatingBackgroundNode{
    SKNode * backgroundNode = [SKNode node];//create the background node
    
    for(int nodeCount = 0; nodeCount < 20; nodeCount++){
        NSString * backgroundImageNamed = [NSString stringWithFormat:@"Background%02d",nodeCount+1];
        SKSpriteNode * node = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageNamed];
        
        node.anchorPoint = CGPointMake(0.5f, 0.6f);
        node.position = CGPointMake(160.0f, nodeCount * 64.0f);
        
        [backgroundNode addChild:node];
    }
    return backgroundNode;
}

-(SKNode *)createMidgroundNode{
    SKNode * midgroundNode = [SKNode node];
    
    for (int i =0; i<10; i++) {
        NSString * spriteName;
        
        int r = arc4random()%2;
        if(r > 0)
            spriteName = @"branchRight";
        else
            spriteName = @"branchLeft";
        
        SKSpriteNode * branchNode = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
        branchNode.position = CGPointMake(160.0f, _endLevelY/10 * i);//500.0f*i);
        [midgroundNode addChild:branchNode];
    }
    
    return midgroundNode;
}

-(StarNode *)createStarAtPosition:(CGPoint)position ofType:(StarType)type{
    
    StarNode * node = [StarNode node];
    [node setPosition:position];
    [node setName:@"NODE_STAR"];
    
    [node setStarType:type];
    SKSpriteNode * sprite;
    if(type == STAR_SPECIAL)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"StarSpecial"];
    else
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
    [node addChild:sprite];
    
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    node.physicsBody.dynamic = NO;
    
    node.physicsBody.categoryBitMask = CollisionCategoryStar;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

#pragma mark - Handling touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (_player.physicsBody.dynamic) return;
    
    [_tapToStart removeFromParent];
    _player.physicsBody.dynamic = YES;
    [_player.physicsBody applyImpulse:CGVectorMake(0.0f, 20.0f)];
    
}


-(void)didBeginContact:(SKPhysicsContact *)contact{
    BOOL updateHud = NO;
    
    SKNode * other = (contact.bodyA.node == _player) ? contact.bodyB.node:contact.bodyA.node;
    
    updateHud = [(GameObjectNode *)other collisionWithPlayer:_player];
    if(updateHud){
        [_lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }
}

#pragma mark - update function


-(void)update:(CFTimeInterval)currentTime {
    if(_gameOver) return;
    
    //this removes the unused stars and platforms
    [_foregroundNode enumerateChildNodesWithName:@"NODE_PLATFORM" usingBlock:^(SKNode * node, BOOL *stop){
        [((PlatformNode *)node)checkNodeRemoval:_player.position.y];
    }];
    [_foregroundNode enumerateChildNodesWithName:@"NODE_STAR" usingBlock:^(SKNode * node, BOOL *stop){
        [((StarNode *)node)checkNodeRemoval:_player.position.y];
    }];
    
    //if the player jumps really high, then move the background as well as the player
    if(_player.position.y > 200.0f){
        _backgroundNode.position = CGPointMake(0.0f, -((_player.position.y -200)/10));
        _midgroundNode.position = CGPointMake(0.0f, -((_player.position.y -200)/4));
        _foregroundNode.position = CGPointMake(0.0f, -((_player.position.y - 200)));
    }//end if
    
    //check max player height
    if(_maxPlayerY < (int)_player.position.y){
        [GameState sharedInstance].score += (int)_player.position.y - _maxPlayerY;
        _maxPlayerY = (int)_player.position.y;
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }//end if
    
    if (_player.position.y > _endLevelY)
        [self endGame];
    
    if (_player.position.y < (_maxPlayerY- 400))
        [self endGame];
}//end function update

-(void)didSimulatePhysics{
    _player.physicsBody.velocity = CGVectorMake(_xAcceleration* 400.0f, _player.physicsBody.velocity.dy);
    
    if (_player.position.x < -20.0f)
        _player.position = CGPointMake(360.0f, _player.position.y);
    else if(_player.position.x > 360.0f)
        _player.position = CGPointMake(-20, _player.position.y);
    
    return;
}

#pragma mark - other stuff

-(void) endGame{
    _gameOver = YES;
    [[GameState sharedInstance] saveState];
    
    SKScene * gameOverScene = [[EndGameScene alloc] initWithSize:self.size];
    SKTransition * reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:gameOverScene transition:reveal];
}



@end
