//
//  TweetDetailsCell.h
//  OSChina
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *appclientLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *likeListLabel;

@end
