//
//  TweetDetailsViewController.m
//  OSChina
//
//  Created by apple on 16/3/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "Utils.h"
#import "OSCTweet.h"
#import "TweetDetailsCell.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@interface TweetDetailsViewController ()<UIWebViewDelegate>

@property(nonatomic, assign) int64_t tweetID;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) OSCTweet *tweet;
@property (nonatomic, assign) CGFloat webViewHeight;

@end

@implementation TweetDetailsViewController

- (instancetype)initWithTweetID:(int64_t)tweetID {

    self = [super initWithCommentType:CommentTypeTweet andObjectID:tweetID];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
        _tweetID = tweetID;
    }
    return self;
}

- (void)viewDidLoad {

    self.needRefreshAnimation = NO;
    [super viewDidLoad];
    
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    _HUD.dimBackground = YES;
    
    [self getTweetDetails];
}

- (void)getTweetDetails {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    [manager GET:[NSString stringWithFormat:@"%@%@?id=%lld",OSCAPI_PREFIX,OSCAPI_TWEET_DETAIL,_tweetID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
        
        ONOXMLElement *tweetDetailsXML = [responseObject.rootElement firstChildWithTag:@"tweet"];
        if (!tweetDetailsXML || tweetDetailsXML.children.count <= 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
        
            _tweet = [[OSCTweet alloc] initWithXML:tweetDetailsXML];
            self.objectAuthorID = _tweet.authorID;
            
            NSDictionary *data = @{@"content": _tweet.body,@"imageURL": _tweet.bigImgURL.absoluteString,@"audioURL": _tweet.attach ?: @"",};
            _tweet.body = [Utils HTMLWithData:data usingTemplate:@"tweet"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [_HUD hide:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {

    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return section == 0? 0 : 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return nil;
    }else {
    
        NSString *title;
        if (self.allCount) {
            title = [NSString stringWithFormat:@"%d 条评论",self.allCount];
        }else {
        
            title = @"没有评论";
        }
        return title;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    }else {
    
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        [self.label setAttributedText:_tweet.likersDetailString];
        self.label.font = [UIFont systemFontOfSize:12];
        CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height + 5;
        height += _webViewHeight;
        return height + 63;
    }else {
    
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        TweetDetailsCell *cell = [TweetDetailsCell new];
        if (_tweet) {
            [cell.portrait loadPortrait:_tweet.portraitURL];
            [cell.authorLabel setText:_tweet.author];
            
            [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetails)]];
            [cell.likeButton addTarget:self action:@selector(togglePraise) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeListLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PushToLikeList)]];
            
            [cell.likeListLabel setAttributedText:_tweet.likersDetailString];
            cell.likeListLabel.hidden = !_tweet.likeList.count;
            [cell.timeLabel setAttributedText:[Utils attributedTimeString:_tweet.pubDate]];
            if (_tweet.isLike) {
                [cell.likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAThumbsOUp] forState:UIControlStateNormal];
                [cell.likeButton setTitleColor:[UIColor nameColor] forState:UIControlStateNormal];
            }else {
                [cell.likeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAThumbsODown] forState:UIControlStateNormal];
                [cell.likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            
            [cell.appclientLabel setAttributedText:[Utils getAppclient:_tweet.appclient]];
            cell.webView.delegate = self;
            [cell.webView loadHTMLString:_tweet.body baseURL:[NSBundle mainBundle].resourceURL];
        }
        return cell;
    }else {
    
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section != 0) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath.section != 0;
}


- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

    return indexPath.section != 0;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    if (_webViewHeight == webViewHeight) {
        return;
    }
    
    _webViewHeight = webViewHeight;
    [_HUD hide:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString hasPrefix:@"file"]) {
        return YES;
    }
    
    [Utils analysis:request.URL.absoluteString andNavController:self.navigationController];
    return [request.URL.absoluteString isEqualToString:@"about:blank"];
}

@end
