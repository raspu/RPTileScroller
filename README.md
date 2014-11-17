# RPTileScroller

<!--[![CI Status](http://img.shields.io/travis/J.P. Illanes/RPTileScroller.svg?style=flat)](https://travis-ci.org/J.P. Illanes/RPTileScroller)
 [![Version](https://img.shields.io/cocoapods/v/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 [![License](https://img.shields.io/cocoapods/l/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 [![Platform](https://img.shields.io/cocoapods/p/RPTileScroller.svg?style=flat)](http://cocoadocs.org/docsets/RPTileScroller)
 -->


![Sample Gif](https://raw.githubusercontent.com/raspu/RPTileScroller/master/RPTileDemo.gif)

A simple tile scroller following a UITableView datasource pattern to get the content. It can be extended to support tiled maps in the future. 



## Notice

**This project is under development and probably not ready for production**


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
	- (SKNode *)tileScroller:(RPTileSc	roller *)tileScroller nodeForIndex:(CGPoint)index
	{
		//Use different identifiers for reusing nodes with the same content (like a tile map). 
	    NSString *idt = @"Your node identifier";  
	       
	    SKSpriteNode *node = (SKSpriteNode *)[tileScroller dequeueReusableNodeWithIdentifier:idt];
	    
	    if(!node)
	    {
	    	//Configure your node here
	        node = [SKSpriteNode spriteNodeWithColor:color size:tileScroller.tileSize];
	        node.identifier = idt;
	    }
	    
	    return node;
	}
```
   

<!--## Installation

RPTileScroller is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "RPTileScroller"
 
## Author

J.P. Illanes, jpillaness@gmail.com
 -->

 
## License

RPTileScroller is available under the MIT license. See the LICENSE file for more info.

