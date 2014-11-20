# RPTileScroller

<!--[![CI Status](http://img.shields.io/travis/J.P. Illanes/RPTileScroller.svg?style=flat)](https://travis-ci.org/J.P. Illanes/RPTileScroller)
 [![Version](https://img.shields.io/cocoapods/v/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 [![License](https://img.shields.io/cocoapods/l/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 [![Platform](https://img.shields.io/cocoapods/p/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 -->


![Sample Gif](https://raw.githubusercontent.com/raspu/RPTileScroller/master/RPTileDemo.gif)

A simple tile scroller following a UITableView's datasource pattern to get the content. It can be extended to support tiled maps. 



## Notice

**This project is under development and probably not ready for production**


## Installation
 
 RPTileScroller is available through [CocoaPods](http://cocoapods.org). To install
 it, simply add the following line to your Podfile:
 
    pod 'RPTileScroller', '~> 0.2'
 
 

## Usage

Import the library

```objectivec
#import <RPTileScroller.h>
```

Instance and configure it

```objectivec
_tileScroller = [[RPTileScroller alloc] initWithSize:view.bounds.size];
_tileScroller.position = CGPointMake(0,0);
_tileScroller.dataSource = self;
_tileScroller.tileSize = CGSizeMake(16, 16);
_tileScroller.backgroundNode.color = [UIColor blackColor];
```

Implement `tileScroller:nodeForIndex:` in the DataSource 

```objectivec
- (SKNode *)tileScroller:(RPTileSc	roller *)tileScroller nodeForIndex:(RPIndexPoint)index
{
    //Use different identifiers for reusing nodes with the same content (like a tile map). 
    NSString *idt = @"Your node identifier";  
       
    SKSpriteNode *node = (SKSpriteNode *)[tileScroller dequeueReusableNodeWithIdentifier:idt];
    
    if(!node)
    {
        node = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:tileScroller.tileSize];
        node.identifier = idt;
        //Configure your node here for position index.x,index.y
    }
    
    return node;
}
```
Call the update method every scene update.

```objectivec
- (void)update:(CFTimeInterval)currentTime 
{
    [_tileScroller update:currentTime];
}
```

Scroll it!

```objectivec
_tileScroller.moveVector = CGVectorMake(15,15); 
```
   

## License

RPTileScroller is available under the MIT license. See the LICENSE file for more info.

