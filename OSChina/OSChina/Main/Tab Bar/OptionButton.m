//
//  OptionButton.m
//  OSChina
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OptionButton.h"
#import "UIColor+Util.h"

@interface OptionButton()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;

@end

@implementation OptionButton

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image andColor:(UIColor *)color {

    if (self = [super init]) {
        _button = [UIImageView new];
        _button.backgroundColor = color;
        
        _image = [UIImageView new];
        _image.image = image;
        [_button addSubview:_image];
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithHex:0x666666];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = title;
        
        [self addSubview:_button];
        [self addSubview:_titleLabel];
        
        [self setLayout];
    }
    return self;
}

- (void)setLayout {

    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.top.equalTo(self).offset(8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.centerX.equalTo(self.button);
    }];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}

@end
