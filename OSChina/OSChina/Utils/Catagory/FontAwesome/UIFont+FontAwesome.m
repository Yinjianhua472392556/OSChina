//
//  UIFont+FontAwesome.m
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@implementation UIFont (FontAwesome)

+ (UIFont *)fontAwesomeFontOfSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
//    NSAssert(font != nil, @"%@ couldn't be loaded",kFontAwesomeFamilyName);
    return font;
}

@end
