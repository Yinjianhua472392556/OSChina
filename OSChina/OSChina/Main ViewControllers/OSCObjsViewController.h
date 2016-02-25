//
//  OSCObjsViewController.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LastCell.h"
#import "OSCAPI.h"
#import "MJRefresh.h"
#import "Ono.h"
#import "UIColor+Util.h"

@interface OSCObjsViewController : UITableViewController

@property (nonatomic, copy) NSString *(^generateURL)(NSUInteger page);
@property (nonatomic, copy) void (^didRefreshSucceed)();
@property (nonatomic, copy) void (^parseExtraInfo)(ONOXMLDocument *);
@property (nonatomic, copy) void (^tableWillReload)(NSUInteger responseObjectsCount);
@property (nonatomic, copy) void (^anotherNetWorking)();

@property Class objClass;

@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) BOOL needRefreshAnimation;
@property (nonatomic, assign) BOOL shouldFetchDataAfterLoaded;
@property (nonatomic, strong) LastCell *lastCell;
@property (nonatomic, assign) int allCount;
@property (nonatomic, assign) BOOL needCache;
@property (nonatomic, assign) BOOL needAutoRefresh;
@property (nonatomic, copy) NSString *kLastRefreshTime;
@property (nonatomic, assign) NSTimeInterval refreshInterval;


@property (nonatomic, strong) UILabel *label;

- (NSArray *)parseXML:(ONOXMLDocument *)xml;
- (void)fetchMore;
- (void)refresh;

@end
