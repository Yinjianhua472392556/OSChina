//
//  BlogsViewController.h
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, BlogsType) {
    BlogsTypeLatest,
    BlogsTypeRecommended,
    
};

@interface BlogsViewController : OSCObjsViewController

- (instancetype)initWithBlogsType:(BlogsType)type;
- (instancetype)initWithUserID:(int64_t)userID;

@end
