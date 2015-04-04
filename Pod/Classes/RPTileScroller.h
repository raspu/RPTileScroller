//
//  RPTileScroller.h
//  SpriteKitTest
//
//  Created by Juan Pablo Illanes Sotta on 02/11/14.
//  Copyright (c) 2014 Raspu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKNode+Indentifier.h"


/**
 *  RP Index, equivalent to CGPoint but with NSInteger.
 */
struct RPIndexPoint{
    NSInteger x;
    NSInteger y;
};
typedef struct RPIndexPoint RPIndexPoint;

CG_INLINE RPIndexPoint
RPIndexPointMake(NSInteger x, NSInteger y)
{
    RPIndexPoint p;
    p.x = x;
    p.y = y;
    return p;
}


@protocol RPTileScrollerDataSource;


/**
 *  RPTileScroller
 */
@interface RPTileScroller : SKCropNode
@property (nonatomic,weak) id<RPTileScrollerDataSource> dataSource;
@property (nonatomic,readonly) SKSpriteNode *backgroundNode; //Use this to give a texture or a color to the background. Do not change it position, unless you know what you are doing.

/**
 *  Size of each tile, defualt [10,10]
 */
@property (nonatomic) CGSize tileSize;

/**
 *  Movement vector, all tiles will be tried to be moved by this vector every 0.1 seconds. 
 */
@property (nonatomic) CGVector moveVector;

/**
 *  Displacement vector, all tiles will be displaced instantly by this vector.
 */
@property (nonatomic) CGVector displacementVector;

/**
 *  Designated initializer.
 *
 *  @param size Size
 *
 *  @return RPTileScroller.
 */
- (id)initWithSize:(CGSize)size;

/**
 *  Call this method in every scene update.
 *
 *  @param currentTime CFTimeInterval
 */
- (void)update:(CFTimeInterval)currentTime;

/**
 *  Tries to dequeue a reusable Node, if no Node is available now, it will return nil. Use the identifier to get pre-configured Nodes, you can use this to avoid changing textures. If the identifier is nil, it will try to dequeue a node wihtout identifier.
 *
 *  @param identifier NSString
 *
 *  @return SKNode
 */
- (SKNode *)dequeueReusableNodeWithIdentifier:(NSString *)identifier;

@end

/**
 *  DataSource
 */
@protocol RPTileScrollerDataSource <NSObject>

/**
 *  Return the Node to be shown in the given index (Beware: The index 0,0 represent the bottom-left corner, and  is a position in the tile array, it's not an actual coordinate). Use dequeueReusableNodeWithIdentifier: to get a reusable Node. If you return nil, no node will be show.
 *
 *  @param index CGPoint to represent an index
 *
 *  @return SKNode
 */
- (SKNode *)tileScroller:(RPTileScroller *)tileScroller nodeForIndex:(RPIndexPoint)index;

@end