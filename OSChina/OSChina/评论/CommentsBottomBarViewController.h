//
//  CommentsBottomBarViewController.h
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BottomBarViewController.h"
#import "CommentsViewController.h"



@interface CommentsBottomBarViewController : BottomBarViewController

- (instancetype)initWithCommentType:(CommentType)commentType andObjectID:(int64_t)objectID;

@end
