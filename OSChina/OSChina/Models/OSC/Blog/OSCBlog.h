//
//  OSCBlog.h
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCBlog : OSCBaseObject

@property (nonatomic, assign) int64_t blogID;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int documentType;
@property (nonatomic, strong) NSMutableAttributedString *attributedTittle;
@property (nonatomic, strong) NSAttributedString *attributedCommentCount;

@end
