//
//  GameScene.m
//  SpriteKitTest
//
//  Created by Juan Pablo Illanes Sotta on 17/10/14.
//  Copyright (c) 2014 Raspu. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
{
    RPTileScroller *_tileScroller;
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view
{    
    _tileScroller = [[RPTileScroller alloc] initWithSize:view.bounds.size];
    _tileScroller.position = CGPointMake(0,0);
    _tileScroller.dataSource = self;
    _tileScroller.tileSize = CGSizeMake(10, 10);
    _tileScroller.backgroundNode.color = [UIColor blackColor];
    
    [self addChild:_tileScroller];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGFloat dx = arc4random_uniform(60);
    CGFloat dy = arc4random_uniform(60);
    _tileScroller.moveVector = CGVectorMake(dx-30,dy-30); 

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [_tileScroller update:currentTime];
}

#pragma mark - Tile Scroller Datasource

- (SKNode *)tileScroller:(RPTileScroller *)tileScroller nodeForIndex:(CGPoint)index
{
    static NSUInteger liveObjects = 0;
    int rnd = arc4random_uniform(6);
    NSString *idt;
    UIColor *color;
    
    switch (rnd)
    {
        case 0:
            idt = @"red";
            color = [UIColor redColor];
            break;
        case 1:
            idt = @"blue";
            color = [UIColor blueColor];
            break;
        case 2:
            idt = @"green";
            color = [UIColor greenColor];
            break;
        case 3:
            idt = @"yellow";
            color = [UIColor yellowColor];
            break;
        case 4:
            idt = @"purple";
            color = [UIColor purpleColor];
            break;
        case 5:
            idt = @"orange";
            color = [UIColor orangeColor];
            break;
            
        default:
            break;
    }
    
    SKSpriteNode *node = (SKSpriteNode *)[tileScroller dequeueReusableNodeWithIdentifier:idt];
    
    if(!node)
    {
        node = [SKSpriteNode spriteNodeWithColor:color size:tileScroller.tileSize];
        node.identifier = idt;
        liveObjects++;
        NSLog(@"Live: %i",liveObjects);
    }
    
    return node;
}

@end