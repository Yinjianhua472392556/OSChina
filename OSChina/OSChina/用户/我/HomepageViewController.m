//
//  HomepageViewController.m
//  OSChina
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HomepageViewController.h"
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "AppDelegate.h"
#import "UIScrollView+ScalableCover.h"
#import "Utils.h"
#import "Config.h"
#import "LoginViewController.h"
#import "OSCMyInfo.h"
#import "MyBasicInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"

@interface HomepageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIButton *creditButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *fanButton;


@property (nonatomic, strong) NSMutableArray *noticeCounts;
@property (nonatomic, strong) OSCMyInfo *myInfo;
@property (nonatomic, assign) int64_t myID;
@property (nonatomic, strong) UIImageView *myQRCodeImageView;
@property (nonatomic, assign) int badgeValue;
@end

@implementation HomepageViewController

- (void)awakeFromNib {

    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeUpdateHandler:) name:OSCAPI_USER_NOTICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefreshHandler:) name:@"userRefresh" object:nil];
    _noticeCounts = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0), @(0), @(0)]];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setUpSubviews];
}

- (void)dawnAndNightMode {

    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    self.refreshControl.tintColor = [UIColor refreshControlColor];
    
    [self refreshHeaderView];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self.tableView reloadData];
    });
}

- (void)refresh {

    _myID = [Config getOwnID];
    if (_myID == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshHeaderView];
            [self.refreshControl endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }else {
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
        [manager GET:[NSString stringWithFormat:@"%@%@?uid=%lld",OSCAPI_PREFIX,OSCAPI_MY_INFORMATION,_myID] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseDocument) {
            
            ONOXMLElement *userXML = [responseDocument.rootElement firstChildWithTag:@"user"];
            _myInfo = [[OSCMyInfo alloc] initWithXML:userXML];
            [Config updateMyInfo:_myInfo];
            [self refreshHeaderView];
            [self.refreshControl endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            MBProgressHUD *HUD = [Utils createHUD];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"网络异常，加载失败";
            [HUD hide:YES afterDelay:1];
            [self.refreshControl endRefreshing];
        }];
    }
}

#pragma mark - customize subviews

- (void)setUpSubviews {

    _creditButton.titleLabel.numberOfLines = 0;
    _creditButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _collectionButton.titleLabel.numberOfLines = 0;
    _collectionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _followingButton.titleLabel.numberOfLines = 0;
    _followingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _fanButton.titleLabel.numberOfLines = 0;
    _fanButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [_collectionButton addTarget:self action:@selector(pushFavoriteSVC) forControlEvents:UIControlEventTouchUpInside];
    [_followingButton addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];
    [_fanButton addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];

    [_portrait setBorderWidth:2.0 andColor:[UIColor whiteColor]];
    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)]];
    [self setCoverImage];
    self.refreshControl.tintColor = [UIColor refreshControlColor];
}

- (void)pushFavoriteSVC {

}

- (void)pushFriendsSVC:(UIButton *)button {


}


- (void)tapPortrait {

    if (![Utils isNetworkExist]) {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"网络无连接,请检查网络";
        [HUD hide:YES afterDelay:1];
    }else {
    
        if ([Config getOwnID] == 0) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
            [self.navigationController pushViewController:loginVC animated:YES];
        }else {
        
            if (_myInfo) {
                [self.navigationController pushViewController:[[MyBasicInfoViewController alloc] initWithMyInformation:_myInfo] animated:YES];
            }else {
            
                [self.navigationController pushViewController:[MyBasicInfoViewController new] animated:YES];
            }
        }
    }
}

- (void)setCoverImage {

    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSString *imageName = @"user-background";
    if (screenWidth.intValue < 400) {
        imageName = [NSString stringWithFormat:@"%@-%@",imageName,screenWidth];
    }
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) {
        imageName = [NSString stringWithFormat:@"%@-dark", imageName];
    }
    if (!self.tableView.scalableCover) {
        [self.tableView addScalableCoverWithImage:[UIImage imageNamed:imageName]];
    }else {
    
        self.tableView.scalableCover.image = [UIImage imageNamed:imageName];
    }
}

#pragma mark - refresh header
- (void)refreshHeaderView {

    NSArray *usersInformation = [Config getUsersInformation];
    if (_myID == 0) {
        _portrait.image = [UIImage imageNamed:@"default-portrait"];
    }else {
    
        UIImage *portrait = [Config getPortrait];
        if (portrait == nil) {
            [_portrait sd_setImageWithURL:_myInfo.portraitURL placeholderImage:[UIImage imageNamed:@"default-portrait"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    return ;
                }
                [Config savePortrait:image];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
            }];
        }else {
            _portrait.image = portrait;
        }
    }
    
    _nameLabel.text = usersInformation[0];
    _separator.backgroundColor = [UIColor lineColor];
    
    [self setCoverImage];
    
    if (_myID == 0) {
        _QRCodeButton.hidden = YES;
        _creditButton.hidden = YES;
        _collectionButton.hidden = YES;
        _followingButton.hidden = YES;
        _fanButton.hidden = YES;
        _separator.hidden = YES;
    }else {
        _QRCodeButton.hidden = NO;
        _creditButton.hidden = NO;
        _collectionButton.hidden = NO;
        _followingButton.hidden = NO;
        _fanButton.hidden = NO;
        _separator.hidden = NO;
        
        
        _QRCodeButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:25];
        [_QRCodeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQrcode] forState:UIControlStateNormal];
        [_QRCodeButton addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
        
        [_creditButton setTitle:[NSString stringWithFormat:@"积分\n%@",usersInformation[1]] forState:UIControlStateNormal];
        [_collectionButton setTitle:[NSString stringWithFormat:@"收藏\n%@",usersInformation[2]] forState:UIControlStateNormal];
        [_followingButton setTitle:[NSString stringWithFormat:@"关注\n%@", usersInformation[3]] forState:UIControlStateNormal];
        [_fanButton setTitle:[NSString stringWithFormat:@"粉丝\n%@", usersInformation[4]] forState:UIControlStateNormal];
    }
}

#pragma mark - 二维码相关
- (void)showQRCode {

    MBProgressHUD *HUD = [Utils createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.color = [UIColor whiteColor];
    
    HUD.labelText = @"扫一扫上面的二维码，加我为好友";
    HUD.labelFont = [UIFont systemFontOfSize:13];
    HUD.labelColor = [UIColor grayColor];
    HUD.customView = self.myQRCodeImageView;
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}

- (void)hideHUD:(UIGestureRecognizer *)recognizer {

    [(MBProgressHUD *)recognizer.view hide:YES];
}

- (UIImageView *)myQRCodeImageView {

    if (!_myQRCodeImageView) {
        UIImage *myQRCode = [Utils createQRCodeFromString:[NSString stringWithFormat:@"http://my.oschina.net/u/%llu",[Config getOwnID]]];
        _myQRCodeImageView = [[UIImageView alloc] initWithImage:myQRCode];
    }
    return _myQRCodeImageView;
}

#pragma mark - 处理通知

- (void)noticeUpdateHandler:(NSNotification *)notification {

    NSArray *noticeCounts = [notification object];
    __block int sumOfCount = 0;
    [noticeCounts enumerateObjectsUsingBlock:^(NSNumber *count, NSUInteger idx, BOOL * _Nonnull stop) {
        _noticeCounts[idx] = count;
        sumOfCount += [count intValue];
    }];
    _badgeValue = sumOfCount;
    if (_badgeValue) {
        self.navigationController.tabBarItem.badgeValue = [@(sumOfCount) stringValue];
    }else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    });
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:sumOfCount];
}

- (void)userRefreshHandler:(NSNotification *)notification {

    _myID = [Config getOwnID];
    [self refreshHeaderView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableView  things
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
    [cell setSelectedBackgroundView:selectedBackground];
    cell.backgroundColor = [UIColor cellsColor];
    
    cell.textLabel.text = @[@"消息", @"博客", @"团队"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@[@"me-message", @"me-blog", @"me-team"][indexPath.row]];
    cell.textLabel.textColor = [UIColor titleColor];

    if (indexPath.row == 0) {
        if (_badgeValue == 0) {
            cell.accessoryView = nil;
        }else {
        
            UILabel *accessoryBadge = [UILabel new];
            accessoryBadge.backgroundColor = [UIColor redColor];
            accessoryBadge.text = [@(_badgeValue) stringValue];
            accessoryBadge.textColor = [UIColor whiteColor];
            accessoryBadge.textAlignment = NSTextAlignmentCenter;
            accessoryBadge.layer.cornerRadius = 11;
            accessoryBadge.clipsToBounds = YES;
            
            CGFloat width = [accessoryBadge sizeThatFits:CGSizeMake(MAXFLOAT, 26)].width + 8;
            width = width > 26 ? width : 22;
            accessoryBadge.frame = CGRectMake(0, 0, width, 22);
            cell.accessoryView = accessoryBadge;
        }
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([Config getOwnID] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            
            break;
            
        default:
            break;
    }
}

@end
