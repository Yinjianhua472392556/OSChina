//
//  SideMenuViewController.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SideMenuViewController.h"
#import "UIColor+Util.h"
#import "AppDelegate.h"
#import "Config.h"
#import "UIImageView+Util.h"
#import "UIView+Util.h"
#import "UIImage+Util.h"
#import "LoginViewController.h"
#import "RESideMenu.h"
#import "AppDelegate.h"
#import "SwipableViewController.h"
#import "PostsViewController.h"

static BOOL isNight;

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"userRefresh" object:nil];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor titleBarColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dawnAndNightMode:) name:@"dawnAndNight" object:nil];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
}

- (void)dawnAndNightMode:(NSNotification *)center {
    [self.tableView reloadData];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSArray *usersInformation = [Config getUsersInformation];
    UIImage *portrait = [Config getPortrait];
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *portraitView = [UIImageView new];
    portraitView.contentMode = UIViewContentModeScaleAspectFit;
    [portraitView setCornerRadius:30];
    portraitView.userInteractionEnabled = YES;
//    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:portraitView];
    
    if (portrait == nil) {
        portraitView.image = [UIImage imageNamed:@"default-portrait"];
    }else {
    
        portraitView.image = portrait;
    }
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = usersInformation[0];
    nameLabel.font = [UIFont boldSystemFontOfSize:20];
    nameLabel.userInteractionEnabled = YES;
    
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        nameLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    } else {
        nameLabel.textColor = [UIColor colorWithHex:0x696969];
    }
    
//    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:nameLabel];

    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(40);
//        make.left.equalTo(headerView);
        make.left.equalTo(@([UIScreen mainScreen].bounds.size.width / 4 - 15));
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitView.mas_bottom).offset(10);
        make.centerX.equalTo(portraitView.mas_centerX);
        make.bottom.equalTo(headerView.mas_bottom).offset(15);
    }];
    
    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
    return headerView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [UITableViewCell new];
    cell.backgroundColor = [UIColor clearColor];
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_QA", @"sidemenu-software", @"sidemenu_blog", @"sidemenu_setting", @"sidemenu-night"][indexPath.row]];
    cell.textLabel.text = @[@"技术问答", @"开源软件", @"博客区", @"设置", @"夜间模式", @"注销"][indexPath.row];
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        if (indexPath.row == 4) {
            cell.textLabel.text = @"日间模式";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-day"];
        }
    } else {
        cell.textLabel.textColor = [UIColor colorWithHex:0x555555];
        if (indexPath.row == 4) {
            cell.textLabel.text = @"夜间模式";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-night"];
        }
    }

    cell.textLabel.font = [UIFont systemFontOfSize:19];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"技术问答" andSubTitles:@[@"提问", @"分享", @"综合", @"职业", @"站务"] andControllers:@[
                                                                                                                                                                       [[PostsViewController alloc] initWithPostsType:PostsTypeQA],
                                                                                                                                                                       [[PostsViewController alloc] initWithPostsType:PostsTypeShare],
                                                                                                                                                                       [[PostsViewController alloc] initWithPostsType:PostsTypeSynthesis],
                                                                                                                                                                       [[PostsViewController alloc] initWithPostsType:PostsTypeCaree],
                                                                                                                                                                       [[PostsViewController alloc] initWithPostsType:PostsTypeSiteManager],
                                                                                                                                                                       ]];
            [self setContentViewController:newsSVC];
            break;
        }
        case 1:
            
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            isNight = [Config getMode];
            if (isNight) {
                ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = NO;
            }else {
                ((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = YES;
            }
            self.tableView.backgroundColor = [UIColor titleBarColor];
            [Config saveWhetherNightMode:!isNight];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dawnAndNight" object:nil];
            break;
        default:
            break;
    }
}
#pragma mark - 点击登录

- (void)pushLoginPage {

    if ([Config getOwnID] == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
        [self setContentViewController:loginVC];
    }else {
        return;
    }
}

- (void)setContentViewController:(UIViewController *)viewController {

    viewController.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)((UITabBarController *)self.sideMenuViewController.contentViewController).selectedViewController;
    [nav pushViewController:viewController animated:NO];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)reload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
@end
