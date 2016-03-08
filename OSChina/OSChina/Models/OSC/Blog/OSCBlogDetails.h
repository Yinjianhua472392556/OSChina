//
//  OSCBlogDetails.h
//  OSChina
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCBlogDetails : OSCBaseObject

@property (nonatomic, assign) int64_t blogID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *where;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, assign) int documentType;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSString *html;

@end
