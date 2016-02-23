//
//  RootViewController.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "SideMenuViewController.h"
#import "OSCTabBarController.h"

@implementation RootViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {

    [super viewDidLoad];
}


- (void)awakeFromNib {

    [super awakeFromNib];
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.95;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OSCTabBarController class])];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SideMenuViewController class])];
}
@end
