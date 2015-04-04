//
//  RPTileScroller.m
//  SpriteKitTest
//
//  Created by Juan Pablo Illanes Sotta on 02/11/14.
//  Copyright (c) 2014 Raspu. All rights reserved.
//

#import "RPTileScroller.h"
#import <objc/runtime.h>


static NSString *const RPRepeatActionKey = @"RP_RepeatActionKey";
static NSString *const RPDefaultIdentifier = @"RP_DefaultIdentifier";

static NSComparisonResult(^xComparisonBlcok)(SKNode *obj1, SKNode *obj2) = ^NSComparisonResult(SKNode *obj1, SKNode *obj2)
{
     return (obj1.position.x == obj2.position.x) ? NSOrderedSame : (obj1.position.x > obj2.position.x) ? NSOrderedDescending : NSOrderedAscending;
};

static NSComparisonResult(^yComparisonBlcok)(SKNode *obj1, SKNode *obj2) = ^NSComparisonResult(SKNode *obj1, SKNode *obj2)
{
    return (obj1.position.y == obj2.position.y) ? NSOrderedSame : (obj1.position.y > obj2.position.y) ? NSOrderedDescending : NSOrderedAscending;
};


@implementation RPTileScroller
{
    //Components
    SKNode *_rootNode;
    
    //Status
    RPIndexPoint _currentIndex;
    
    //Counts
    NSInteger _calculatedRows;
    NSInteger _calculatedCols;
    
    //Meta Data
    CGSize _selfSize;
    NSMutableDictionary *_availableNodes;
    NSMutableArray *_xIndex;
    NSMutableArray *_yIndex;
}
@synthesize moveVector = _moveVector, displacementVector = _displacementVector, tileSize = _tileSize;

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    if(self)
    {
        //Base Components
        _selfSize = size;
        //self.yScale = -1;
        SKSpriteNode *maskNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:size];
        maskNode.anchorPoint = CGPointMake(0, 0);
        maskNode.position = CGPointMake(0, 0);
        self.maskNode = maskNode;
        
        _rootNode = [SKNode node];
        _rootNode.zPosition = 1;
        _rootNode.position = CGPointMake(0, 0);
        
        _backgroundNode = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:size];
        _backgroundNode.anchorPoint = CGPointMake(0, 0);
        _backgroundNode.position = CGPointMake(0, 0);
        _backgroundNode.zPosition = 0;
        
        _tileSize = CGSizeMake(10, 10);
        _moveVector = CGVectorMake(0, 0);
        
        [self addChild:_backgroundNode];
        [self addChild:_rootNode];
        
        //Meta Data
        _xIndex = [NSMutableArray array]; //Nodes in the view, sorted by x (ASC)
        _yIndex = [NSMutableArray array]; //Nodes in the view, sorted by y (ASC)
        _availableNodes = [NSMutableDictionary dictionary];
        
        //Status
        _currentIndex = RPIndexPointMake(-2, -2);
    }
    return self;
}

#pragma mark - Properties

- (void)setTileSize:(CGSize)tileSize
{
    _tileSize = tileSize;
    _calculatedCols = (_selfSize.width/_tileSize.width)+4;
    _calculatedRows = (_selfSize.height/_tileSize.height)+4;
    [self reloadData];
}

- (void)setDataSource:(id<RPTileScrollerDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)setMoveVector:(CGVector)moveVector
{
    _moveVector = moveVector;
    [_rootNode removeActionForKey:RPRepeatActionKey];
    SKAction *action = [SKAction moveBy:moveVector duration:0.1];
    [_rootNode runAction:[SKAction repeatActionForever:action] withKey:RPRepeatActionKey];
}

- (void)setDisplacementVector:(CGVector)displacement
{
    _displacementVector = displacement;
    _rootNode.position = CGPointMake(_rootNode.position.x + displacement.dx, _rootNode.position.y + displacement.dy);
}

#pragma mark - Public Methods

- (SKNode *)dequeueReusableNodeWithIdentifier:(NSString *)identifier
{
    if(!identifier)
        identifier = RPDefaultIdentifier;
    
    SKNode *result = nil;
    
    @synchronized(_availableNodes)
    {
        NSMutableArray *nodeArray = [_availableNodes objectForKey:identifier];
        if(nodeArray)
        {
            result = [nodeArray firstObject];
            if(result)
            {
                [nodeArray removeObjectAtIndex:0];
            }
        }

    }
    
    return result;
}


- (void)update:(CFTimeInterval)currentTime
{
    RPIndexPoint newIndex = RPIndexPointMake(floor(_rootNode.position.x/_tileSize.width)*-1-2, floor(_rootNode.position.y/_tileSize.height)*-1-2);
    
    if(newIndex.x == _currentIndex.x && newIndex.y == _currentIndex.y)
        return; //Nothing to do!
   

    //Moving on x axis
    if(newIndex.x != _currentIndex.x && (_moveVector.dx != 0 || _displacementVector.dx != 0))
    {
        if(_moveVector.dx>0 || _displacementVector.dx>0)
        {
            [self autoEnqueueXNodesInverted:NO];
            for (NSInteger i=newIndex.x; i<_currentIndex.x; i++)
            {
                for (NSInteger j=_currentIndex.y-1; j<_calculatedRows+_currentIndex.y+1; j++)
                {
                    RPIndexPoint index = RPIndexPointMake(i, j);
                    SKNode *node = [_dataSource tileScroller:self nodeForIndex:index];
                    if(node)
                        [self insertNode:node atIndex:index];
                }
            }
        }else
        {
            [self autoEnqueueXNodesInverted:YES];
            for (NSInteger i=_currentIndex.x+_calculatedCols; i<newIndex.x+_calculatedCols; i++)
            {
                for (NSInteger j=_currentIndex.y-1; j<_calculatedRows+_currentIndex.y+1; j++)
                {
                    //NSLog(@"%i,%i",i,j);
                    RPIndexPoint index = RPIndexPointMake(i, j);
                    SKNode *node = [_dataSource tileScroller:self nodeForIndex:index];
                    if(node)
                        [self insertNode:node atIndex:index];
                }
            }

        }
        
    }
    
    //Moving on y axis
    if(newIndex.y != _currentIndex.y && (_moveVector.dy != 0 || _displacementVector.dy != 0))
    {
        if(_moveVector.dy>0 || _displacementVector.dy>0)
        {
            [self autoEnqueueYNodesInverted:NO];
            for (NSInteger j=newIndex.y; j<_currentIndex.y; j++)
            {
                for (NSInteger i=_currentIndex.x; i<_calculatedCols+_currentIndex.x; i++)
                {
                    RPIndexPoint index = RPIndexPointMake(i, j);
                    SKNode *node = [_dataSource tileScroller:self nodeForIndex:index];
                    if(node)
                        [self insertNode:node atIndex:index];
                }
            }
        }else
        {
            [self autoEnqueueYNodesInverted:YES];
            for (NSInteger j=_currentIndex.y+_calculatedRows; j<newIndex.y+_calculatedRows; j++)
            {
                for (NSInteger i=_currentIndex.x; i<_calculatedCols+_currentIndex.x; i++)
                {
                    RPIndexPoint index = RPIndexPointMake(i, j);
                    SKNode *node = [_dataSource tileScroller:self nodeForIndex:index];
                    if(node)
                        [self insertNode:node atIndex:index];
                }
            }
            
        }
        
    }
    
    _currentIndex = newIndex;
}

- (void)reloadData
{
    if(!_dataSource || _calculatedCols == 0 || _calculatedRows == 0)
        return;
    
    [_rootNode.children enumerateObjectsUsingBlock:^(SKNode *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromParent];
        [self enqueueReusableNode:obj withIdentifier:obj.identifier];
    }];
    
    [_xIndex removeAllObjects];
    [_yIndex removeAllObjects];
    
    for(NSInteger i=_currentIndex.x; i<_currentIndex.x+_calculatedCols; i++)
    {
        for (NSInteger j=_currentIndex.y; j<_currentIndex.y+_calculatedRows; j++)
        {
            RPIndexPoint index = RPIndexPointMake(i, j);
            SKNode *node = [_dataSource tileScroller:self nodeForIndex:index];
            if(node)
               [self insertNode:node atIndex:index];
        }
    }
    

}

#pragma mark - Private Methods



- (void)enqueueReusableNode:(SKNode *)node withIdentifier:(NSString *)identifier
{
    if(!identifier)
        identifier = RPDefaultIdentifier;
    @synchronized(_availableNodes)
    {
        NSMutableArray *nodeArray = [_availableNodes objectForKey:identifier];
        if(!nodeArray)
        {
            nodeArray = [NSMutableArray arrayWithCapacity:1];
            [_availableNodes setObject:nodeArray forKey:identifier];
        }
        [nodeArray addObject:node];

    }
}

- (void)insertNode:(SKNode *)node atIndex:(RPIndexPoint)point
{

    //NSLog(@"%f,%f",node.position.x,node.position.y);
    node.position = CGPointMake(point.x*_tileSize.width, point.y*_tileSize.height);

    [_xIndex insertObject:node atIndex:[self xIndexOfNode:node withSearchOptions:NSBinarySearchingInsertionIndex]];
    [_yIndex insertObject:node atIndex:[self yIndexOfNode:node withSearchOptions:NSBinarySearchingInsertionIndex]];

    //[node removeFromParent];
    
    [_rootNode addChild:node];
    
    
}

#pragma mark - Indexes Managment

- (void)autoEnqueueXNodesInverted:(BOOL)inverted
{
    BOOL goOn = YES;
    
    while (_xIndex.count > 0 && goOn)
    {
        SKNode *node;
        if(inverted)
        {
            node = [_xIndex objectAtIndex:0];
        }else
        {
            node = [_xIndex lastObject];
        }
        
        CGPoint positionOnBkg = [self.scene convertPoint:node.position fromNode:_rootNode];

        if(positionOnBkg.x > _backgroundNode.size.width+_tileSize.width*2 || positionOnBkg.x < _tileSize.width*-2)
        {
            [node removeFromParent];
            
            if(inverted)
            {
                [_xIndex removeObjectAtIndex:0];
            }else
            {
                [_xIndex removeLastObject];
                
            }
            
            [self yIndexRemoveObject:node];
            [self enqueueReusableNode:node withIdentifier:node.identifier];
        }else
        {
            goOn = NO;
        }
        
    }
    
}

- (void)autoEnqueueYNodesInverted:(BOOL)inverted
{
    BOOL goOn = YES;
    
    while (_yIndex.count > 0 && goOn)
    {
        SKNode *node ;
        if(inverted)
        {
            node = [_yIndex objectAtIndex:0];
        }else
        {
            node = [_yIndex lastObject];
        }
        
        CGPoint positionOnBkg = [self.scene convertPoint:node.position fromNode:_rootNode];

        if(positionOnBkg.y > _backgroundNode.size.height+_tileSize.height*2 || positionOnBkg.y < _tileSize.height*-2)
        {
            [node removeFromParent];
            
            if(inverted)
            {
                [_yIndex removeObjectAtIndex:0];
            }else
            {
                [_yIndex removeLastObject];

            }
            
            [self xIndexRemoveObject:node];
            [self enqueueReusableNode:node withIdentifier:node.identifier];
        }else
        {
            goOn = NO;
        }
        
    }
    
}

- (void)xIndexRemoveObject:(SKNode *)node
{
    NSUInteger objectIndex = [self xIndexOfNode:node withSearchOptions:NSBinarySearchingFirstEqual];
    
    if(objectIndex != NSNotFound)
    {
        [_xIndex removeObjectAtIndex:objectIndex];
    }
}

- (void)yIndexRemoveObject:(SKNode *)node
{
    NSUInteger objectIndex = [self yIndexOfNode:node withSearchOptions:NSBinarySearchingFirstEqual];
    
    if(objectIndex != NSNotFound)
    {
        [_yIndex removeObjectAtIndex:objectIndex];
    }
}

- (NSUInteger)xIndexOfNode:(SKNode *)node withSearchOptions:(NSBinarySearchingOptions) options
{
    return [_xIndex indexOfObject:node
                    inSortedRange:(NSRange){0, [_xIndex count]}
                          options: options
                  usingComparator:
            ^NSComparisonResult(SKNode *obj1, SKNode *obj2)
            {
                NSInteger result;
                
                if(obj1.position.x != obj2.position.x)
                {
                    result = (obj1.position.x > obj2.position.x) ? NSOrderedDescending : NSOrderedAscending;
                }else
                {
                    result = (obj1.position.y == obj2.position.y) ? NSOrderedSame : (obj1.position.y > obj2.position.y) ? NSOrderedDescending : NSOrderedAscending;
                }
                
                return result;
            }];
}

- (NSUInteger)yIndexOfNode:(SKNode *)node withSearchOptions:(NSBinarySearchingOptions) options
{
    return [_yIndex indexOfObject:node
                    inSortedRange:(NSRange){0, [_yIndex count]}
                          options: options
                  usingComparator:
            ^NSComparisonResult(SKNode *obj1, SKNode *obj2)
            {
                NSInteger result;
                
                if(obj1.position.y != obj2.position.y)
                {
                    result = (obj1.position.y > obj2.position.y) ? NSOrderedDescending : NSOrderedAscending;
                }else
                {
                    result = (obj1.position.x == obj2.position.x) ? NSOrderedSame : (obj1.position.x > obj2.position.x) ? NSOrderedDescending : NSOrderedAscending;
                }
                
                return result;
            }];
}

@end

