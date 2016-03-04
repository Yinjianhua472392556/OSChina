//
//  GrowingTextView.h
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface GrowingTextView : PlaceholderTextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, assign, readonly) CGFloat maxHeight;
- (instancetype)initWithPlaceholder:(NSString *)placeholder;
- (CGFloat)measureHeight;

@end
