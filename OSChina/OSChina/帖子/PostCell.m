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
@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor themeColor];
        [self initSubviews];
        [self setLayout];
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

- (void)setLayout {

    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(36));
        make.height.equalTo(@(36));
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.titleLabel).offset(8);
        make.top.equalTo(self.contentView).offset(5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portrait);
        make.bottom.equalTo(self.bodyLabel).offset(5);
    }];
    
    [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.authorLabel).offset(5);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleLabel);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.timeLabel).offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentAndView).offset(10);
        make.top.equalTo(self.authorLabel);
    }];
    [self.commentAndView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.authorLabel);
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bodyLabel.frame);
    [super layoutSubviews];
}

@end
