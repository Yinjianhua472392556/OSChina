//
//  OSCBaseObject.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono/Ono.h>
#import <TBXML/TBXML.h>

@interface OSCBaseObject : NSObject

- (instancetype)initWithXML:(ONOXMLElement *)xml;
- (instancetype)initWithTBXMLElement:(TBXMLElement*)element;

@end
