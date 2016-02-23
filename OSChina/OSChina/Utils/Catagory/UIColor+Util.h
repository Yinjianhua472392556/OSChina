//
//  UIColor+Util.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(int)hexValue;
+ (UIColor *)navigationbarColor;
+ (UIColor *)titleBarColor;
+ (UIColor *)nameColor;
+ (UIColor *)selectCellSColor;
+ (UIColor *)themeColor;
+ (UIColor *)titleColor;
+ (UIColor *)separatorColor;
+ (UIColor *)contentTextColor;
+ (UIColor *)cellsColor;
+ (UIColor *)borderColor;

@end
