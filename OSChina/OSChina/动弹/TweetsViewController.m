//
//  TweetsViewController.m
//  OSChina
//
//  Created by apple on 16/2/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TweetsViewController.h"
#import "Config.h"
#import "OSCTweet.h"
#import "TweetCell.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Config.h"
#import "OSCUser.h"

static NSString * const kTweetCellID = @"TweetCell";

@interface TweetsViewController ()
@property (nonatomic, assign) int64_t uid;
@property (nonatomic, copy) NSString *topic;
@property(nonatomic, strong) NSMutableDictionary *offscreenCells;
@end

@implementation TweetsViewController

#pragma mark - init method

- (instancetype)initWithTweetsType:(TweetsType)type {

    self = [super init];
    if (self) {
        switch (type) {
            case TweetsTypeAllTweets: {
                _uid = 0;
                break;
            }
            case TweetsTypeHotestTweets: {
                _uid = -1;
                break;
            }
            case TweetsTypeOwnTweets: {
                _uid = [Config getOwnID];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefreshHandler:) name:@"userRefresh" object:nil];
                if (_uid == 0) {
                    //显示提示页面
                }
                break;
            }
        }
        self.needAutoRefresh = type != TweetsTypeOwnTweets;
        self.refreshInterval = type == TweetsTypeAllTweets? 360 : 3600;
        self.kLastRefreshTime = [NSString stringWithFormat:@"TweetsRefreshInterval-%ld",type];
        [self setBlockAndClass];
    }
    return self;
}

- (instancetype)initWithUserID:(int64_t)userID {

    self = [super init];
    if (self) {
        _uid = userID;
        [self setBlockAndClass];
    }
    return self;
}

- (instancetype)initWithSoftwareID:(int64_t)softwareID {

    self = [super init];
    if (self) {
        self.generateURL = ^NSString * (NSUInteger page) {
        
            return [NSString stringWithFormat:@"%@%@?project=%lld&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_SOFTWARE_TWEET_LIST,softwareID,page,OSCAPI_SUFFIX];
        };
        self.objClass = [OSCTweet class];
    }
    return self;
}

- (instancetype)initWithTopic:(NSString *)topic {

    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _topic = topic;
        self.generateURL = ^NSString *(NSUInteger page){
            NSString *URL = [NSString stringWithFormat:@"%@%@?title=%@&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_TWEET_TOPIC_LIST,topic,page,OSCAPI_SUFFIX];
            return [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        };
        self.objClass = [OSCTweet class];
        self.navigationItem.title = topic;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(topicEditing)];
    }
    return self;
}

- (void)setBlockAndClass {

    __weak TweetsViewController *weakSelf = self;
    self.tableWillReload = ^(NSUInteger responseObjectsCount){
    
        if (weakSelf.uid == -1) {
            weakSelf.lastCell.status = LastCellStatusFinished;
        }else {
            responseObjectsCount < 20? (weakSelf.lastCell.status = LastCellStatusFinished) : (weakSelf.lastCell.status = LastCellStatusMore);
        }
    };
    
    self.generateURL = ^NSString * (NSUInteger page) {
        return [NSString stringWithFormat:@"%@%@?uid=%lld&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_TWEETS_LIST,weakSelf.uid,page,OSCAPI_SUFFIX];
    };
    
    self.objClass = [OSCTweet class];
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {

    return [[xml.rootElement firstChildWithTag:@"tweets"] childrenWithTag:@"tweet"];
}

#pragma mark - life cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:kTweetCellID];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view things

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    OSCTweet *tweet = self.objects[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kTweetCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor themeColor];
    [self setBlockForCommentCell:cell];
    [cell setContentWithTweet:tweet];
    if (tweet.hasAnImage) {
        cell.thumbnail.hidden = NO;
        [cell.thumbnail sd_setImageWithURL:tweet.smallImgURL placeholderImage:[UIImage imageNamed:@"loading"]];

    }else {
        cell.thumbnail.hidden = YES;
    }
    
    cell.portrait.tag = row;
    cell.authorLabel.tag = row;
    cell.thumbnail.tag = row;
    cell.likeButton.tag = row;
    cell.likeListLabel.tag = row;
    cell.contentLabel.textColor = [UIColor contentTextColor];
    cell.authorLabel.textColor = [UIColor nameColor];
    
//    [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetailsView:)]];
//    [cell.thumbnail addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadLargeImage:)]];
//    [cell.likeButton addTarget:self action:@selector(togglePraise:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.likeListLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushToLikeList:)]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    OSCTweet *tweet = self.objects[indexPath.row];
//    if (tweet.cellHeight) {
//        return tweet.cellHeight;
//    }
//    
//    TweetCell *cell = [self.offscreenCells objectForKey:kTweetCellID];
//    if (!cell) {
//        cell = [[TweetCell alloc] init];
//        [self.offscreenCells setValue:cell forKey:kTweetCellID];
//    }
//    
//    [cell setContentWithTweet:tweet];
//    
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    if (tweet.hasAnImage) {
//        height += 86;
//    }
//    height += 10;
//    tweet.cellHeight = height;
//    return tweet.cellHeight;
    
    OSCTweet *tweet = self.objects[indexPath.row];
    
    if (tweet.cellHeight) {return tweet.cellHeight;}
    
    self.label.font = [UIFont boldSystemFontOfSize:14];
    [self.label setText:tweet.author];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)].height;
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    [self.label setAttributedText:[Utils emojiStringFromRawString:tweet.body]];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)].height;
    
    if (tweet.likeCount) {
        [self.label setAttributedText:tweet.likersString];
        self.label.font = [UIFont systemFontOfSize:12];
        height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 60, MAXFLOAT)].height + 6;
    }
    
    if (tweet.hasAnImage) {
        height += 86;
    }
    tweet.cellHeight = height + 39;
    
    return tweet.cellHeight;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

    return action == @selector(copyText:);
} 

#pragma mark - 处理消息通知
- (void)userRefreshHandler:(NSNotification *)notification {

    _uid = [Config getOwnID];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
    });
}

#pragma mark - 编辑话题动弹
- (void)topicEditing {

    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_didScroll) {
        _didScroll();
    }
}

- (void)setBlockForCommentCell:(TweetCell *)cell {

    cell.canPerformAction = ^BOOL (UITableViewCell *cell, SEL action){
    
        if (action == @selector(copyText:)) {
            return YES;
        }else if (action == @selector(deleteObject:)) {
        
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            OSCTweet *tweet = self.objects[indexPath.row];
            return tweet.authorID == [Config getOwnID];
        }
        return NO;
    };
    
    cell.deleteObject = ^(UITableViewCell *cell) {
    
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        OSCTweet *tweet = self.objects[indexPath.row];
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.labelText = @"正在删除动弹";
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
        [manager POST:[NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_TWEET_DELETE] parameters:@{@"uid" : @([Config getOwnID]), @"tweetid" : @(tweet.tweetID)} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument  *responseObject) {
            
            ONOXMLElement *resultXML = [responseObject.rootElement firstChildWithTag:@"result"];
            int errorCode = [[[resultXML firstChildWithTag:@"errorCode"] numberValue] intValue];
            NSString *errorMessage = [[resultXML firstChildWithTag:@"errorMessage"] stringValue];
            HUD.mode = MBProgressHUDModeCustomView;
            if (errorCode == 1) {
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                HUD.labelText = @"动弹删除成功";
                [self.objects removeObjectAtIndex:indexPath.row];
                self.allCount--;
                if (self.objects.count > 0) {
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [self.tableView endUpdates];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else {
            
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                HUD.labelText = [NSString stringWithFormat:@"错误:%@",errorMessage];
            }
            [HUD hide:YES afterDelay:1];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
            [HUD hide:YES afterDelay:1];
        }];
    };
}

#pragma mark - 点赞功能
- (void)togglePraise:(UIButton *)button {
    OSCTweet *tweet = self.objects[button.tag];
    [self toPraise:tweet];
}

- (void)toPraise:(OSCTweet *)tweet {

    NSString *postUrl;
    if (tweet.isLike) {
        postUrl = [NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_TWEET_UNLIKE];
    }else {
    
        postUrl = [NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_TWEET_LIKE];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    [manager POST:postUrl parameters:@{@"uid" : @([Config getOwnID]), @"tweetid" : @(tweet.tweetID), @"ownerOfTweet" : @(tweet.authorID)} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
        
        ONOXMLElement *resultXML = [responseObject.rootElement firstChildWithTag:@"result"];
        int errorCode = [[[resultXML firstChildWithTag:@"errorCode"] numberValue] intValue];
        NSString *errorMessage = [[resultXML firstChildWithTag:@"errorMessage"] stringValue];
        if (errorCode == 1) {
            if (tweet.isLike) {
                //取消点赞
                for (OSCUser *user in tweet.likeList) {
                    if ([user.name isEqualToString:[Config getOwnUserName]]) {
                        [tweet.likeList removeObject:user];
                        break;
                    }
                }
                tweet.likeCount--;
            }else {
            //点赞
                OSCUser *user = [OSCUser new];
                user.userID = [Config getOwnID];
                user.name = [Config getOwnUserName];
                user.portraitURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[Config getPortrait]]];
                [tweet.likeList insertObject:user atIndex:0];
                tweet.likeCount++;
            }
            tweet.isLike = !tweet.isLike;
            tweet.likersString = nil;
            tweet.cellHeight = 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }else {
        
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.labelText = [NSString stringWithFormat:@"错误:%@",errorMessage];
            [HUD hide:YES afterDelay:1];
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
        [HUD hide:YES afterDelay:1];
    }];
}

#pragma mark - 下载图片
//- (void)downloadImageThenReload:(NSURL *)imageURL {
//
//}

#pragma mark - 懒加载
- (NSMutableDictionary *)offscreenCells {
    
    if (_offscreenCells == nil) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}
@end
