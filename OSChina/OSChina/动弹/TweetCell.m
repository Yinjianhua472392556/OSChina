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


@interface TweetCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation TweetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor themeColor];
        
        _thumbnailConstraints = [NSArray new];
        _noThumbnailConstraints = [NSArray new];
        UIView *selectedBackground = [UIView new];
        selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
        [self setSelectedBackgroundView:selectedBackground];
        
        [self initSubviews];
//        [self setLayout];
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
    _thumbnail.backgroundColor = [UIColor cyanColor];
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


- (void)setLayout
{
    for (UIView *view in self.contentView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _authorLabel, _timeLabel, _appclientLabel, _contentLabel, _likeButton, _commentCount, _likeListLabel, _thumbnail);
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_portrait(36)]" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-8-[_authorLabel]-8-|"
                                                                             options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_authorLabel]-5-[_contentLabel]-<=6-[_thumbnail(80)]-<=6-[_likeListLabel]-6-[_timeLabel]-5-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_thumbnail(80)]"
                                                                             options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_timeLabel]-10-[_appclientLabel]->=5-[_likeButton(30)]-5-[_commentCount]-8-|"
                                                                             options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_likeListLabel]-8-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_authorLabel  attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                                    toItem:_contentLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
}

- (void)updateConstraints {

    if (!self.didSetupConstraints) {
        
        [_portrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.width.with.height.equalTo(@(36));
        }];
     
        [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_portrait.mas_right).offset(8);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.top.equalTo(self.contentView.mas_top).offset(7);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorLabel.mas_left);
            make.top.equalTo(_authorLabel.mas_bottom).offset(5);
            make.right.equalTo(_authorLabel.mas_right);
        }];
        
        [_thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorLabel.mas_left);
            make.top.lessThanOrEqualTo(_contentLabel.mas_bottom).offset(6);
//            make.top.equalTo(_contentLabel.mas_bottom).offset(6);
            make.width.height.equalTo(@(80));
        }];
        [_likeListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorLabel.mas_left);
            make.top.lessThanOrEqualTo(_thumbnail.mas_bottom).offset(6);
//            make.top.equalTo(_thumbnail.mas_bottom).offset(6);
            make.right.equalTo(self.contentView.mas_right).offset(8);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_authorLabel.mas_left);
            make.top.equalTo(_likeListLabel.mas_bottom).offset(6);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
            
            make.centerY.equalTo(@[_appclientLabel.mas_centerY, _likeButton.mas_centerY,_commentCount.mas_centerY]);
        }];
        
        [_appclientLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeLabel.mas_right).offset(10);
        }];
        
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(_appclientLabel.mas_right).offset(5);
//            make.left.equalTo(_appclientLabel.mas_left).offset(5);
            make.width.equalTo(@(30));
        }];
        
        [_commentCount mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_likeButton.mas_right).offset(5);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
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
