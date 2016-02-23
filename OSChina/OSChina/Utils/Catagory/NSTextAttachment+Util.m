//
//  NSTextAttachment+Util.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSTextAttachment+Util.h"

@implementation NSTextAttachment (Util)

- (void)adjustY:(CGFloat)y {

    self.bounds = CGRectMake(0, y, self.image.size.width, self.image.size.height);
}

@end
