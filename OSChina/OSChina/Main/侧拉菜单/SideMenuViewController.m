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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    
//}
@end
