//
//  TweetDetailsViewController.h
//  OSChina
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentsViewController.h"

@interface TweetDetailsViewController : CommentsViewController

- (instancetype)initWithTweetID:(int64_t)tweetID;

@end
