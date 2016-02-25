//
//  PostsViewController.h
//  OSChina
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"
typedef NS_ENUM(int, PostsType) {
    PostsTypeQA = 1,
    PostsTypeShare,
    PostsTypeSynthesis,
    PostsTypeCaree,
    PostsTypeSiteManager,
};
@interface PostsViewController : OSCObjsViewController

- (instancetype)initWithPostsType:(PostsType)type;

@end
