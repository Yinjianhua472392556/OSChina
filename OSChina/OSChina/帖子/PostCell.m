//
//  PostCell.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PostCell.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"

@interface PostCell()
@property(nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor themeColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {

    self.portrait = [UIImageView new];
    self.portrait.contentMode = UIViewContentModeScaleAspectFit;
    [self.portrait setCornerRadius:5.0];
    [self.contentView addSubview:self.portrait];
    
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];

    self.bodyLabel = [UILabel new];
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bodyLabel.font = [UIFont systemFontOfSize:13];
    self.bodyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.bodyLabel];

    self.authorLabel = [UILabel new];
    self.authorLabel.font = [UIFont systemFontOfSize:12];
    self.authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];

    self.commentAndView = [UILabel new];
    self.commentAndView.font = [UIFont systemFontOfSize:12];
    self.commentAndView.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.commentAndView];

}


- (void)updateConstraints {

    if (!self.didSetupConstraints) {
        
        [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(36));
            make.height.equalTo(@(36));
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portrait.mas_top);
            make.left.equalTo(self.portrait.mas_right).offset(8);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
        }];
        
        [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.equalTo(self.titleLabel.mas_right);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bodyLabel.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
            make.left.equalTo(self.titleLabel.mas_left);
            make.centerY.equalTo(@[self.timeLabel.mas_centerY,self.commentAndView.mas_centerY]);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.authorLabel.mas_right).offset(10);
        }];
        [self.commentAndView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-8);
        }];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}

@end
