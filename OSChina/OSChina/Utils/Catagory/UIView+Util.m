//
//  UIView+Util.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+Util.h"
#import <GPUImage/GPUImage.h>

@implementation UIView (Util)

-(void)setCornerRadius:(CGFloat)cornerRadius {

    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color {

    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (UIImage *)convertViewToImage {

    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

- (UIImage *)updateBlur {
    UIImage *screenshot = [self convertViewToImage];
    GPUImageiOSBlurFilter *blurFilter = [GPUImageiOSBlurFilter new];
    blurFilter.saturation = 1.0;
    blurFilter.rangeReductionFactor = 0.1;
    UIImage *blurImage = [blurFilter imageByFilteringImage:screenshot];

    return blurImage;
}

@end
