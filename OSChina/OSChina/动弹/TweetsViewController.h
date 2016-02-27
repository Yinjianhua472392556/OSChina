//
//  TweetsViewController.h
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, TweetsType) {
    TweetsTypeAllTweets,
    TweetsTypeHotestTweets,
    TweetsTypeOwnTweets,
};

@interface TweetsViewController : OSCObjsViewController

@property (nonatomic, copy) void (^didScroll)();

- (instancetype)initWithTweetsType:(TweetsType)type;
- (instancetype)initWithUserID:(int64_t)userID;
- (instancetype)initWithSoftwareID:(int64_t)softwareID;
- (instancetype)initWithTopic:(NSString *)topic;

@end
