//
//  OSCNews.h
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

typedef NS_ENUM(NSUInteger, NewsType) {
    NewsTypeStandardNews,
    NewsTypeSoftWare,
    NewsTypeQA,
    NewsTypeBlog
};

@interface OSCNews : OSCBaseObject

@property (nonatomic, assign) int64_t newsID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, assign) NewsType type;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *eventURL;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, assign) int64_t authorUID2;
@property (nonatomic, strong) NSMutableAttributedString *attributedTittle;
@property (nonatomic, strong) NSAttributedString *attributedCommentCount;

@end
