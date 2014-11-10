//
//  SKNode+Indentifier.m
//  SpriteKitTest
//
//  Created by Juan Pablo Illanes Sotta on 03/11/14.
//  Copyright (c) 2014 Raspu. All rights reserved.
//
#import <objc/runtime.h>
#import "SKNode+Indentifier.h"

static char const * const RPIdentifierTag = "RP_IdentifierTag";

@implementation SKNode (Indentifier)
@dynamic identifier;

- (void)setIdentifier:(NSString *)identifier
{
    objc_setAssociatedObject(self, RPIdentifierTag, identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSString *)identifier
{
    return objc_getAssociatedObject(self, RPIdentifierTag);
}




@end
