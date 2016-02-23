//
//  OSCBaseObject.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@implementation OSCBaseObject

- (instancetype)initWithXML:(ONOXMLElement *)xml {

    NSAssert(false, @"Over ride in subclasses");
    return nil;
}

- (instancetype)initWithTBXMLElement:(TBXMLElement *)element {

    NSAssert(false, @"Over ride in TBXML subclasses");
    return nil;
}

@end
