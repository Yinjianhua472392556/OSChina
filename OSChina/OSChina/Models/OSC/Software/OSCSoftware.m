//
//  OSCSoftware.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCSoftware.h"

static NSString * const kName = @"name";
static NSString * const kDescription = @"description";
static NSString * const kURL = @"url";

@implementation OSCSoftware

- (instancetype)initWithXML:(ONOXMLElement *)xml {

    if (self = [super init]) {
        _name = [[xml firstChildWithTag:kName] stringValue];
        _softwareDescription = [[xml firstChildWithTag:kDescription] stringValue];
        _url = [NSURL URLWithString:[[xml firstChildWithTag:kURL] stringValue]];
    }
    return self;
}

- (BOOL)isEqual:(id)object {

    return NO;
}

@end
