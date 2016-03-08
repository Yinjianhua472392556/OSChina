//
//  CommentsViewController.h
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, CommentType) {
    CommentTypeNews = 1,
    CommentTypePost,
    CommentTypeTweet,
    CommentTypeMessageCenter,
    CommentTypeBlog,
    CommentTypeSoftware,
};

@class OSCComment;

@interface CommentsViewController : OSCObjsViewController

@property (nonatomic, assign) int64_t objectAuthorID;
@property (nonatomic, copy) void (^didCommentSelected)(OSCComment *comment);
@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithCommentType:(CommentType)commentType andObjectID:(int64_t)objectID;
@end
