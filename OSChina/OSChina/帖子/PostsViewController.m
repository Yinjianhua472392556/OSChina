//
//  PostsViewController.m
//  OSChina
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PostsViewController.h"
#import "OSCPost.h"
#import "PostCell.h"
#import "UIImageView+Util.h"
#import "Utils.h"
static NSString *kPostCellID = @"PostCell";

@interface PostsViewController ()
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@end

@implementation PostsViewController

- (instancetype)initWithPostsType:(PostsType)type {

    self = [super init];
    if (self) {
        self.generateURL = ^NSString *(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_POSTS_LIST,type,(unsigned long)page,OSCAPI_SUFFIX];
        };
        self.objClass = [OSCPost class];
    }
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {

    return [[xml.rootElement firstChildWithTag:@"posts"] childrenWithTag:@"post"];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[PostCell class] forCellReuseIdentifier:kPostCellID];
}

#pragma mark -  tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
    OSCPost *post = self.objects[indexPath.row];
    
    [cell.portrait loadPortrait:post.portraitURL];
    [cell.titleLabel setText:post.title];
    [cell.bodyLabel setText:post.body];
    [cell.authorLabel setText:post.author];
    [cell.timeLabel setText:[Utils intervalSinceNow:post.pubDate]];
    [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅",post.replyCount,post.viewCount]];
    cell.titleLabel.textColor = [UIColor titleColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OSCPost *post = self.objects[indexPath.row];
    NSString *reuseIdentifier = kPostCellID;
    PostCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[PostCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    [cell.portrait loadPortrait:post.portraitURL];
    [cell.titleLabel setText:post.title];
    [cell.bodyLabel setText:post.body];
    [cell.authorLabel setText:post.author];
    [cell.timeLabel setText:[Utils intervalSinceNow:post.pubDate]];
    [cell.commentAndView setText:[NSString stringWithFormat:@"%d回 / %d阅",post.replyCount,post.viewCount]];

    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat  height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 10;
    return height;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)offscreenCells {

    if (_offscreenCells == nil) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}
@end
