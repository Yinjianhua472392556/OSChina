//
//  NewsCell.m
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewsCell.h"
#import "UIColor+Util.h"

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self initSubviews];
        [self setLayout];
    }
    return self;
}


- (void)initSubviews {

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
    self.authorLabel.numberOfLines = 0;
    self.authorLabel.font = [UIFont systemFontOfSize:12];
    self.authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];

    self.commentCount = [UILabel new];
    self.commentCount.numberOfLines = 0;
    self.commentCount.font = [UIFont systemFontOfSize:12];
    self.commentCount.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.commentCount];

}

- (void)setLayout {

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(8);
        make.top.equalTo(self.contentView.mas_top).offset(8);
    }];
    
    [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyLabel.mas_left);
        make.top.equalTo(self.bodyLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(8);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_right).offset(5);
        make.centerY.equalTo(self.authorLabel.mas_centerY);
    }];
    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
}


- (void)layoutSubviews {

    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bodyLabel.frame);
    self.authorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.authorLabel.frame);
    self.timeLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.timeLabel.frame);
    self.commentCount.preferredMaxLayoutWidth = CGRectGetWidth(self.commentCount.frame);
    [super layoutSubviews];

}

@end
