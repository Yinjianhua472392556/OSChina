//
//  DetailsViewController.m
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailsViewController.h"
#import "OSCNews.h"
#import "OSCBlog.h"
#import "OSCPost.h"
#import "OSCSoftware.h"
#import "CommentsViewController.h"
#import "OSCNewsDetails.h"
#import "OSCSoftwareDetails.h"
#import "OSCPostDetails.h"
#import "OSCBlogDetails.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "Config.h"
#import "UIBarButtonItem+Badge.h"
#import "Config.h"

@interface DetailsViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) OSCNews *news;
@property (nonatomic, assign) int64_t objectID;
@property (nonatomic, copy) NSString *detailsURL;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) FavoriteType favoriteType;
@property (nonatomic, assign) Class detailsClass;
@property (nonatomic ,assign) SEL loadMethod;
@property (nonatomic, assign) CommentType commentType;
@property (nonatomic, copy) NSString *softwareName;
@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, assign) BOOL isStarred;
@property (nonatomic, assign, readonly) int commentCount;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *objectTitle;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, copy) NSString *mURL;

@end

@implementation DetailsViewController

#pragma mark - 初始化方法
- (instancetype)initWithNews:(OSCNews *)news {
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        _news = news;
        _objectID = news.newsID;
        switch (news.type) {
            case NewsTypeStandardNews: {
                self.navigationItem.title = @"资讯详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld",OSCAPI_PREFIX,OSCAPI_NEWS_DETAIL,news.newsID];
                _tag = @"news";
                _commentType = CommentTypeNews;
                _favoriteType = FavoriteTypeNews;
                _detailsClass = [OSCNewsDetails class];
                _loadMethod = @selector(loadNewsDetails:);
                break;
            }
            case NewsTypeSoftWare: {
                self.navigationItem.title = @"软件详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?ident=%@",OSCAPI_PREFIX,OSCAPI_SOFTWARE_DETAIL,news.attachment];
                _tag = @"software";
                _commentType = CommentTypeSoftware;
                _favoriteType = FavoriteTypeSoftware;
                _detailsClass = [OSCSoftwareDetails class];
                _loadMethod = @selector(loadSoftwareDetails:);
                break;
            }
            case NewsTypeQA: {
                self.navigationItem.title = @"帖子详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%@",OSCAPI_PREFIX,OSCAPI_POST_DETAIL,news.attachment];
                _tag = @"post";
                _objectID = [news.attachment longLongValue];
                _commentType = CommentTypePost;
                _favoriteType = FavoriteTypeTopic;
                _detailsClass = [OSCPostDetails class];
                _loadMethod = @selector(loadPostDetails:);
                break;
            }
            case NewsTypeBlog: {
                self.navigationItem.title = @"博客详情";
                _detailsURL = [NSString stringWithFormat:@"%@%@?id=%@",OSCAPI_PREFIX,OSCAPI_BLOG_DETAIL,news.attachment];
                _tag = @"blog";
                _commentType = CommentTypeBlog;
                _favoriteType = FavoriteTypeBlog;
                _objectID = [news.attachment longLongValue];
                _detailsClass = [OSCBlogDetails class];
                _loadMethod = @selector(loadBlogDetails:);
                break;
            }
        }
        
    }
    return self;
}

- (instancetype)initWithBlog:(OSCBlog *)blog {

    self = [super initWithModeSwitchButton:YES];
    if (self) {
        _commentType = CommentTypeBlog;
        _favoriteType = FavoriteTypeBlog;
        _objectID = blog.blogID;
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"博客详情";
        _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld",OSCAPI_PREFIX,OSCAPI_BLOG_DETAIL,blog.blogID];
        _tag = @"blog";
        _detailsClass = [OSCBlogDetails class];
        _loadMethod = @selector(loadBlogDetails:);
    }
    return self;
}

- (instancetype)initWithPost:(OSCPost *)post {
    self = [super initWithModeSwitchButton:YES];
    if (!self) {return nil;}
    
    _commentType = CommentTypePost;
    _favoriteType = FavoriteTypeTopic;
    _objectID = post.postID;
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"帖子详情";
    _detailsURL = [NSString stringWithFormat:@"%@%@?id=%lld", OSCAPI_PREFIX, OSCAPI_POST_DETAIL, post.postID];
    _tag = @"post";
    _detailsClass = [OSCPostDetails class];
    _loadMethod = @selector(loadPostDetails:);
    
    return self;
}

- (instancetype)initWithSoftware:(OSCSoftware *)software {
    self = [super initWithModeSwitchButton:YES];
    if (!self) {return nil;}
    
    _commentType = CommentTypeSoftware;
    _favoriteType = FavoriteTypeSoftware;
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"软件详情";
    _detailsURL = [NSString stringWithFormat:@"%@%@?ident=%@", OSCAPI_PREFIX, OSCAPI_SOFTWARE_DETAIL, software.url.absoluteString.lastPathComponent];
    _tag = @"software";
    _softwareName = software.name;
    _detailsClass = [OSCSoftwareDetails class];
    _loadMethod = @selector(loadSoftwareDetails:);
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    // 资讯、博客和软件详情没有“举报”选项
    if (_commentType == CommentTypeNews || _commentType == CommentTypeSoftware || _commentType == CommentTypeBlog) {
        self.operationBar.items = [self.operationBar.items subarrayWithRange:NSMakeRange(0, 12)];
    }
    
    _detailsView = [UIWebView new];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.opaque = NO;
    _detailsView.backgroundColor = [UIColor themeColor];
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_detailsView];
    
    [self.view bringSubviewToFront:(UIView *)self.editingBar];
    
    NSDictionary *views = @{@"detailsView": _detailsView, @"bottomBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailsView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailsView][bottomBar]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    [self.editingBar.modeSwitchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 添加等待动画
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    _manager = [AFHTTPRequestOperationManager OSCManager];
    [self fetchDetails];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];

    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

    [_HUD hide:YES];
    [super viewWillDisappear:animated];
}


- (void)fetchDetails {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    [manager GET:_detailsURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseDocument) {
        
        NSString *response = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        TBXML *XML = [[TBXML alloc] initWithXMLString:response error:nil];
        ONOXMLElement *onoXML = [responseDocument.rootElement firstChildWithTag:_tag];
        if (!onoXML || onoXML.children.count <= 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
        
            id details;
            if ([_tag isEqualToString:@"blog"] || [_tag isEqualToString:@"post"]) {//tbxml
                TBXMLElement *element = XML.rootXMLElement;
                TBXMLElement *subElement = [TBXML childElementNamed:_tag parentElement:element];
                details = [[_detailsClass alloc] initWithTBXMLElement:subElement];
            }else {//onoxml
            
                ONOXMLElement *XML = [responseDocument.rootElement firstChildWithTag:_tag];
                details = [[_detailsClass alloc] initWithXML:XML];
            }
            [self performSelector:_loadMethod withObject:details];
            self.operationBar.isStarred = _isStarred;
            
            UIBarButtonItem *commentsCountButton = self.operationBar.items[4];
            commentsCountButton.shouldHideBadgeAtZero = YES;
            commentsCountButton.badgeValue = [NSString stringWithFormat:@"%i",_commentCount];
            commentsCountButton.badgePadding = 1;
            commentsCountButton.badgeBGColor = [UIColor colorWithHex:0x24a83d];
            if (_commentType == CommentTypeSoftware) {
                _objectID = ((OSCSoftwareDetails *)details).softwareID;
            }
            
            [self setBlockForOperationBar];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

- (void)refresh {

    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self fetchDetails];
}

#pragma mark -
- (void)setBlockForOperationBar {

    __weak typeof(self) weakSelf = self;
    /********* 收藏 **********/

    self.operationBar.toggleStar = ^ {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
        NSString *API = weakSelf.isStarred? OSCAPI_FAVORITE_DELETE : OSCAPI_FAVORITE_ADD;
        [manager POST:[NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,API] parameters:@{@"uid" : @([Config getOwnID]), @"objid" : @(weakSelf.objectID),@"type" : @(weakSelf.favoriteType)} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
            
            ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
            int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
            NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
            
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            
            if (errorCode == 1) {
                
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                HUD.labelText = weakSelf.isStarred ? @"删除收藏成功" : @"添加收藏成功";
                weakSelf.isStarred = !weakSelf.isStarred;
                weakSelf.operationBar.isStarred = weakSelf.isStarred;
                
            }else {
                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                HUD.labelText = [NSString stringWithFormat:@"错误：%@", errorMessage];

            }
            [HUD hide:YES afterDelay:1];
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.labelText = @"网络异常，操作失败";
            
            [HUD hide:YES afterDelay:1];

        }];
    };
    
    
    /********** 显示回复 ***********/
    self.operationBar.showComments = ^ {
    
        if (weakSelf.commentType == CommentTypeSoftware) {
            
        }else {
        
        }
    };
    
    /********** 分享设置 ***********/

    self.operationBar.share = ^ {
    
    };
    
    /*********** 举报 ************/

    self.operationBar.report = ^{
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"举报" message:[NSString stringWithFormat:@"链接地址：%@",weakSelf.webURL] delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertView textFieldAtIndex:0].placeholder = @"举报原因";
        if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
            [alertView textFieldAtIndex:0].keyboardAppearance = UIKeyboardAppearanceDark;
        }

        [alertView show];
    };

}


- (void)loadNewsDetails:(OSCNewsDetails *)newsDetails {

    [self.detailsView loadHTMLString:newsDetails.html baseURL:[[NSBundle mainBundle] resourceURL]];
    _isStarred = newsDetails.isFavorite;
    _webURL = [newsDetails.url absoluteString];
    _objectTitle = newsDetails.title;
    _commentCount = newsDetails.commentCount;
    NSString *trimmedHTML = [Utils deleteHTMLTag:newsDetails.body];
    NSInteger length = trimmedHTML.length < 60 ? trimmedHTML.length : 60;
    _digest = [[Utils deleteHTMLTag:newsDetails.body] substringToIndex:length];
    
}

- (void)loadBlogDetails:(OSCBlogDetails *)blogDetails {

    [self.detailsView loadHTMLString:blogDetails.html baseURL:[[NSBundle mainBundle] resourceURL]];
    _isStarred = blogDetails.isFavorite;
    _webURL = [blogDetails.url absoluteString];
    _objectTitle = blogDetails.title;
    _commentCount = blogDetails.commentCount;
    NSString *trimmedHTML = [Utils deleteHTMLTag:blogDetails.body];
    NSInteger length = trimmedHTML.length < 60 ? trimmedHTML.length : 60;
    _digest = [[Utils deleteHTMLTag:blogDetails.body] substringToIndex:length];
}

- (void)loadPostDetails:(OSCPostDetails *)postDetails {
    [self.detailsView loadHTMLString:postDetails.html baseURL:[[NSBundle mainBundle] resourceURL]];
    
    _isStarred = postDetails.isFavorite;
    _webURL = [postDetails.url absoluteString];
    _commentCount = postDetails.answerCount;
    _objectTitle = postDetails.title;
    
    NSString *trimmedHTML = [Utils deleteHTMLTag:postDetails.body];
    NSInteger length = trimmedHTML.length < 60 ? trimmedHTML.length : 60;
    _digest = [[Utils deleteHTMLTag:postDetails.body] substringToIndex:length];
}

- (void)loadSoftwareDetails:(OSCSoftwareDetails *)softwareDetails {
    [self.detailsView loadHTMLString:softwareDetails.html baseURL:[[NSBundle mainBundle] resourceURL]];
    
    _isStarred = softwareDetails.isFavorite;
    _webURL = [softwareDetails.url absoluteString];
    
    _commentCount = softwareDetails.tweetCount;
    _objectTitle = [NSString stringWithFormat:@"%@ %@", softwareDetails.extensionTitle, softwareDetails.title];
    
    NSString *trimmedHTML = [Utils deleteHTMLTag:softwareDetails.body];
    NSInteger length = trimmedHTML.length < 60 ? trimmedHTML.length : 60;
    _digest = [[Utils deleteHTMLTag:softwareDetails.body] substringToIndex:length];
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != [alertView cancelButtonIndex]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.oschina.net/action/communityManage/report" parameters:@{@"memo":        [alertView textFieldAtIndex:0].text.length == 0? @"其他原因": [alertView textFieldAtIndex:0].text, @"obj_id" : @(_objectID), @"obj_type" : @"4", @"url": _webURL} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
            
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.labelText = @"举报成功";
            
            [HUD hide:YES afterDelay:1];

        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.labelText = @"网络异常，操作失败";
            
            [HUD hide:YES afterDelay:1];
            
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView != self.editingBar.editView) {
        [self.editingBar.editView resignFirstResponder];
        [self hideEmojiPageView];
    }
}

#pragma mark - 浏览器链接处理

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString hasPrefix:@"file"]) {
        return YES;
    }
    [Utils analysis:[request.URL absoluteString] andNavController:self.navigationController];
    return [request.URL.absoluteString isEqualToString:@"about:blank"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [_HUD hide:YES];
}

#pragma mark - 发表评论

- (void)sendContent {
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.labelText = @"评论发送中";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    NSString *URL;
    NSDictionary *parameters;
    NSString *content = [Utils convertRichTextToRawText:self.editingBar.editView];
    if (_commentType == CommentTypeSoftware) {
        URL = [NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_TWEET_PUB];
        parameters = @{@"uid" : @([Config getOwnID]), @"msg" : [content stringByAppendingString:[NSString stringWithFormat:@" #%@#",_softwareName]]};
    }else if (_commentType == CommentTypeBlog) {
    
        URL = [NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_BLOGCOMMENT_PUB];
        parameters = @{@"blog" : @(_objectID), @"uid" : @([Config getOwnID]), @"content" : content, @"reply_id" : @(0), @"objuid" : @(0)};
        
    }else {
    
        URL = [NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_COMMENT_PUB];
        parameters = @{@"catalog": @(_commentType), @"id": @(_objectID), @"uid": @([Config getOwnID]), @"content": content, @"isPostToMyZone": @(0)};
    }
    
    [manager POST:URL parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseDocument) {
        
        ONOXMLElement *result = [responseDocument.rootElement firstChildWithTag:@"result"];
        int errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] intValue];
        NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
        HUD.mode = MBProgressHUDModeCustomView;
        if (errorCode == 1) {
            self.editingBar.editView.text = @"";
            [self updateInputBarHeight];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.labelText = @"评论发表成功";
        }else {
        
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            HUD.labelText = [NSString stringWithFormat:@"错误：%@",errorMessage];
        }
        
        [HUD hide:YES afterDelay:2];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.labelText = @"网络异常，动弹发送失败";
        [HUD hide:YES afterDelay:2];
    }];
}

#pragma mark - 暂时没做处理

- (NSString *)mURL {

    if (_mURL) {
        return _mURL;
    }else {
    
        NSMutableString *strUrl = [NSMutableString stringWithFormat:@"%@",_webURL];
        if (_commentType == CommentTypeBlog) {
            strUrl = [NSMutableString stringWithFormat:@"http://m.oschina.net/blog/%lld",_objectID];
        }else {
        
            [strUrl replaceCharactersInRange:NSMakeRange(7, 3) withString:@"m"];
        }
        _mURL = [strUrl copy];
        return _mURL;
    }
}

@end
