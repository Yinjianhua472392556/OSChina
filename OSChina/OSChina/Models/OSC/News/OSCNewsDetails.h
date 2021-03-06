//
//  OSCNewsDetails.h
//  OSChina
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCNewsDetails : OSCBaseObject

@property (nonatomic, assign) int64_t newsID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) ino64_t authorID;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, copy) NSURL *softwareLink;
@property (nonatomic, copy) NSString *softwareName;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, strong) NSArray *relatives;
@property (nonatomic, copy) NSString *html;

@end
