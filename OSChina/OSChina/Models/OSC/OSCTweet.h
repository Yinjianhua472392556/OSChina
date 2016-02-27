//
//  OSCTweet.h
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCTweet : OSCBaseObject

@property (nonatomic, assign) int64_t tweetID;
@property (nonatomic, copy) NSURL *portraitURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) int appclient;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) BOOL hasAnImage;
@property (nonatomic, strong) NSURL *smallImgURL;
@property (nonatomic, strong) NSURL *bigImgURL;
@property (nonatomic, copy) NSString *attach;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, copy) NSMutableArray *likeList;
@property (nonatomic, copy) NSMutableAttributedString *likersString;
@property (nonatomic, copy) NSMutableAttributedString *likersDetailString;
@property (nonatomic, copy) NSAttributedString *attributedCommentCount;
@property (nonatomic, assign) CGFloat cellHeight;


@end
