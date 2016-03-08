//
//  DetailsViewController.h
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BottomBarViewController.h"

typedef NS_ENUM(NSUInteger, DetailsType) {
    DetailsTypeNews,
    DetailsTypeBlog,
    DetailsTypeSoftware,
};

typedef NS_ENUM(NSUInteger, FavoriteType) {
    FavoriteTypeSoftware,
    FavoriteTypeTopic,
    FavoriteTypeBlog,
    FavoriteTypeNews,
    FavoriteTypeCode,
};

@class OSCNews;
@class OSCBlog;
@class OSCPost;
@class OSCSoftware;

@interface DetailsViewController : BottomBarViewController

- (instancetype)initWithNews:(OSCNews *)news;
- (instancetype)initWithBlog:(OSCBlog *)blog;
- (instancetype)initWithPost:(OSCPost *)post;
- (instancetype)initWithSoftware:(OSCSoftware *)software;

@end
