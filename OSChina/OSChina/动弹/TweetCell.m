//
//  TweetCell.m
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TweetCell.h"
#import "OSCTweet.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "UIImageView+Util.h"
#import "Utils.h"

@implementation TweetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor themeColor];
        
        _thumbnailConstraints = [NSArray new];
        _noThumbnailConstraints = [NSArray new];
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
        [self setSelectedBackgroundView:selectedBackground];
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

- (void)initSubviews {
    _portrait = [UIImageView new];
    _portrait.contentMode = UIViewContentModeScaleAspectFit;
    _portrait.userInteractionEnabled = YES;
    [_portrait setCornerRadius:5.0];
    [self.contentView addSubview:_portrait];
    
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont boldSystemFontOfSize:14];
    _authorLabel.userInteractionEnabled = YES;
    _authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:_authorLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];

    _appclientLabel = [UILabel new];
    _appclientLabel.font = [UIFont systemFontOfSize:12];
    _appclientLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_appclientLabel];

    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_contentLabel];

    _likeButton = [UIButton new];
    _likeButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:12];
    [self.contentView addSubview:_likeButton];

    _commentCount = [UILabel new];
    _commentCount.font = [UIFont systemFontOfSize:12];
    _commentCount.textColor = [UIColor grayColor];
    [self.contentView addSubview:_commentCount];
    
    _thumbnail = [UIImageView new];
    _thumbnail.contentMode = UIViewContentModeScaleAspectFill;
    _thumbnail.clipsToBounds = YES;
    _thumbnail.userInteractionEnabled = YES;
    [self.contentView addSubview:_thumbnail];

    //点赞列表
    _likeListLabel = [UILabel new];
    _likeListLabel.numberOfLines = 0;
    _likeListLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _likeListLabel.font = [UIFont systemFontOfSize:12];
    _likeListLabel.userInteractionEnabled = YES;
    _likeListLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_likeListLabel];
}

- (void)setLayout {

    [self.portrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(36));
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(8);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portrait.mas_right).offset(8);
        make.top.equalTo(self.portrait.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(8);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_left);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(5);
        make.right.equalTo(self.authorLabel.mas_right);
    }];
    
    [self.thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(80));
        make.left.equalTo(self.authorLabel.mas_left);
        make.top.lessThanOrEqualTo(self.contentLabel.mas_bottom).offset(6);
    }];
    
    [self.likeListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_left);
        make.top.lessThanOrEqualTo(self.thumbnail.mas_bottom).offset(6);
        make.right.equalTo(self.authorLabel.mas_right);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_left);
        make.top.equalTo(self.likeListLabel.mas_bottom).offset(6);
    }];
    
    [self.appclientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(30));
        make.left.mas_greaterThanOrEqualTo(self.appclientLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.left.equalTo(self.likeButton.mas_right).offset(5);
    }];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    self.likeListLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.likeListLabel.frame);
    [super layoutSubviews];
    
}

- (void)setContentWithTweet:(OSCTweet *)tweet {

    [_portrait loadPortrait:tweet.portraitURL];
    _authorLabel.text = tweet.author;
    
    _timeLabel.attributedText = [Utils attributedTimeString:tweet.pubDate];
    _commentCount.attributedText = tweet.attributedCommentCount;
    _appclientLabel.attributedText = [Utils getAppclient:tweet.appclient];
    if (tweet.isLike) {
        [_likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAThumbsUp] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
    }else {
    
        [_likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAThumbsOUp] forState:UIControlStateNormal];
        [_likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    // 添加语音图片
    if (tweet.attach.length) {
        //有语音
        NSTextAttachment *textAttachment = [NSTextAttachment new];
        textAttachment.image = [UIImage imageNamed:@"audioTweet"];
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSMutableAttributedString *attributedTweetBody = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
        [attributedTweetBody appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
        [attributedTweetBody appendAttributedString:[Utils emojiStringFromRawString:tweet.body]];
        
        _contentLabel.attributedText = attributedTweetBody;
    }else {
    
        _contentLabel.attributedText = [Utils emojiStringFromRawString:tweet.body];
    }
    
    _likeListLabel.attributedText = tweet.likersString;
    
    if (tweet.likeList.count > 0) {
        _likeListLabel.hidden = NO;
    }else {
    
        _likeListLabel.hidden = YES;
    }
    
}
#pragma mark - 处理长按操作

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    return _canPerformAction(self,action);
}

- (BOOL)canBecomeFirstResponder {

    return YES;
}

- (void)copyText:(id)sender {

    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:_contentLabel.text];
}

- (void)deleteObject:(id)sender {
    _deleteObject(self);
}

@end
