//
//  NewsViewController.h
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, NewsListType) {
    NewsListTypeAllType = 0,
    NewsListTypeNews,
    NewsListTypeSynthesis,
    NewsListTypeSoftwareRenew,
    NewsListTypeAllTypeWeekHottest,
    NewsListTypeAllTypeMonthHottest,
};

@interface NewsViewController : OSCObjsViewController

- (instancetype)initWithNewsListType:(NewsListType)type;

@end
