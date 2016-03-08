//
//  OSCPostDetails.h
//  OSChina
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCPostDetails : OSCBaseObject

@property (nonatomic, assign) int64_t postID;
@property (nonatomic, assign) ino64_t authorID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *portraitURL;
@property (nonatomic, assign) int answerCount;
@property (nonatomic, assign) int viewCount;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign, readonly) int status;
@property (nonatomic, assign, readonly) int applyStatus;
@property (nonatomic, assign, readonly) int category;
@property (nonatomic, copy) NSURL *signUpUrl;
@property (nonatomic, copy) NSString *html;

@end
