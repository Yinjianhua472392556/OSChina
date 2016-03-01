//
//  NewsViewController.m
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewsViewController.h"
#import "OSCNews.h"
#import "NewsCell.h"
#import "Utils.h"

static NSString *kNewsCellID = @"NewsCell";

@interface NewsViewController ()
@property(nonatomic, strong) NSMutableDictionary *offscreenCells;
@end

@implementation NewsViewController

- (instancetype)initWithNewsListType:(NewsListType)type {

    self = [super init];
    if (self) {
        __weak NewsViewController *weakSelf = self;
        self.generateURL = ^NSString *(NSUInteger page){
            if (type < 4) {
                return [NSString stringWithFormat:@"%@%@?catalog=%lu&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_NEWS_LIST,(unsigned long)type,page,OSCAPI_SUFFIX];
            }else if (type == NewsListTypeAllTypeWeekHottest) {
            
                return [NSString stringWithFormat:@"%@%@?show=week",OSCAPI_PREFIX,OSCAPI_NEWS_LIST];
            }else {
            
                return [NSString stringWithFormat:@"%@%@?show=month",OSCAPI_PREFIX,OSCAPI_NEWS_LIST];
            }
        };
        
        self.tableWillReload = ^(NSUInteger responseObjectsCount){
        
            if (type > 4) {
                weakSelf.lastCell.status = LastCellStatusFinished;
            }else {
            
                responseObjectsCount < 20? (weakSelf.lastCell.status = LastCellStatusFinished) : (weakSelf.lastCell.status = LastCellStatusMore);
            }
        };
        
        self.objClass = [OSCNews class];
        self.needAutoRefresh = YES;
        self.refreshInterval = 21600;
        self.kLastRefreshTime = [NSString stringWithFormat:@"NewsRefreshInterval-%lu",(unsigned long)type];
    }
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {

    return [[xml.rootElement firstChildWithTag:@"newslist"] childrenWithTag:@"news"];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:kNewsCellID];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;

}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellID forIndexPath:indexPath];
    OSCNews *news = self.objects[indexPath.row];
    cell.backgroundColor = [UIColor themeColor];
    
    cell.titleLabel.attributedText = news.attributedTittle;
    cell.bodyLabel.text = news.body;
    cell.authorLabel.text = news.author;
    cell.titleLabel.textColor = [UIColor titleColor];
    cell.timeLabel.attributedText = [Utils attributedTimeString:news.pubDate];
    cell.commentCount.attributedText = news.attributedCommentCount;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OSCNews *news = self.objects[indexPath.row];
    NewsCell *cell = [self.offscreenCells objectForKey:kNewsCellID];
    if (!cell) {
        cell = [[NewsCell alloc] init];
        [self.offscreenCells setObject:cell forKey:kNewsCellID];
    }
    
    cell.titleLabel.attributedText = news.attributedTittle;
    cell.bodyLabel.text = news.body;
    cell.authorLabel.text = news.author;
    cell.titleLabel.textColor = [UIColor titleColor];
    cell.timeLabel.attributedText = [Utils attributedTimeString:news.pubDate];
    cell.commentCount.attributedText = news.attributedCommentCount;

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];


    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 10;
    return height;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 懒加载
- (NSMutableDictionary *)offscreenCells {

    if (_offscreenCells == nil) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}

@end
