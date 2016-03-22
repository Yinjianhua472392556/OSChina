//
//  BlogsViewController.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BlogsViewController.h"
#import "OSCBlog.h"
#import "BlogCell.h"
#import "Config.h"
#import "Utils.h"
#import "DetailsViewController.h"

static NSString *kBlogCellID = @"BlogCell";


@interface BlogsViewController ()
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@end

@implementation BlogsViewController

- (instancetype)initWithBlogsType:(BlogsType)type {

    if (self = [super init]) {
        NSString *blogType = type == BlogsTypeLatest? @"latest" : @"recommend";
        self.generateURL = ^NSString *(NSUInteger page){
            return [NSString stringWithFormat:@"%@%@?type=%@&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_BLOGS_LIST,blogType,page,OSCAPI_SUFFIX];
        };
        self.objClass = [OSCBlog class];
        self.needAutoRefresh = YES;
        self.refreshInterval = 7200;
        self.kLastRefreshTime = [NSString stringWithFormat:@"BlogsRefreshInterval-%ld",type];
    }
    return self;
}

- (instancetype)initWithUserID:(int64_t)userID {

    if (self = [super init]) {
        self.generateURL = ^NSString *(NSUInteger page){
            return [NSString stringWithFormat:@"%@%@?authoruid=%lld&pageIndex=%lu&uid=%lld",OSCAPI_PREFIX,OSCAPI_USERBLOGS_LIST,userID,page,[Config getOwnID]];
        };
        self.objClass = [OSCBlog class];
    }
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {

    return [[xml.rootElement firstChildWithTag:@"blogs"] childrenWithTag:@"blog"];
}

#pragma mark - life cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[BlogCell class] forCellReuseIdentifier:kBlogCellID];
}

#pragma mark - tableView things

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:kBlogCellID forIndexPath:indexPath];
    OSCBlog *blog = self.objects[indexPath.row];
    cell.backgroundColor = [UIColor themeColor];
    
    cell.titleLabel.attributedText = blog.attributedTittle;
    cell.bodyLabel.text = blog.body;
    cell.authorLabel.text = blog.author;
    cell.titleLabel.textColor = [UIColor titleColor];
    cell.timeLabel.attributedText = [Utils attributedTimeString:blog.pubDate];
    cell.commentCount.attributedText = blog.attributedCommentCount;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    

    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
     return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OSCBlog *blog = self.objects[indexPath.row];
    NSString *reuseIdentifier = kBlogCellID;
    BlogCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[BlogCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    cell.titleLabel.attributedText = blog.attributedTittle;
    cell.bodyLabel.text = blog.body;
    cell.authorLabel.text = blog.author;
    cell.titleLabel.textColor = [UIColor titleColor];
    cell.timeLabel.attributedText = [Utils attributedTimeString:blog.pubDate];
    cell.commentCount.attributedText = blog.attributedCommentCount;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
     CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 15;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    OSCBlog *blog = self.objects[indexPath.row];
    DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithBlog:blog];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)offscreenCells {

    if (_offscreenCells == nil) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}
@end
