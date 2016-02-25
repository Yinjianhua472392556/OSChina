//
//  OSCSoftwareCatalog.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCSoftwareCatalog.h"

static NSString * const kName = @"name";
static NSString * const kTag  = @"tag";

@implementation OSCSoftwareCatalog

- (instancetype)initWithXML:(ONOXMLElement *)xml {

    if (self = [super init]) {
        
        _name = [[xml firstChildWithTag:kName] stringValue];
        _tag = [[[xml firstChildWithTag:kTag] numberValue] intValue];
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return NO;
}


@end
