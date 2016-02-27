//
//  TweetCell.h
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCTweet;

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *commentCount;
@property (nonatomic, strong) UILabel *appclientLabel; //显示APP设备(如：iphone,Android)
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *likeListLabel;
@property (nonatomic, strong) UIImageView *thumbnail; //缩略图

@property (nonatomic, strong) NSArray *thumbnailConstraints;
@property (nonatomic, strong) NSArray *noThumbnailConstraints;

@property (nonatomic, copy) BOOL (^canPerformAction)(UITableViewCell *cell, SEL action);
@property (nonatomic, copy) void (^deleteObject)(UITableViewCell *cell);

- (void)setContentWithTweet:(OSCTweet *)tweet;
- (void)copyText:(id)sender;
- (void)deleteObject:(id)sender;

@end
