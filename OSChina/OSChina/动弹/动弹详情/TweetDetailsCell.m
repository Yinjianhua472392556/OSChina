//
//  TweetDetailsCell.m
//  OSChina
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TweetDetailsCell.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIFont+FontAwesome.h"

@implementation TweetDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor themeColor];
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
    _authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:_authorLabel];

    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    _appclientLabel = [UILabel new];
    _appclientLabel.font = [UIFont systemFontOfSize:14];
    _appclientLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_appclientLabel];

    _likeButton = [UIButton new];
    _likeButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:14];
    [self.contentView addSubview:_likeButton];
    
    _webView = [UIWebView new];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor themeColor];
    [self.contentView addSubview:_webView];
    
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

    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _authorLabel, _timeLabel, _appclientLabel, _webView, _likeButton, _likeListLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_portrait(36)][_webView]-8-[_likeListLabel]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_webView]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_likeListLabel]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-5-[_authorLabel]-8-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_authorLabel]-2-[_timeLabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_timeLabel]-5-[_appclientLabel]->=5-[_likeButton(50)]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
}

@end
