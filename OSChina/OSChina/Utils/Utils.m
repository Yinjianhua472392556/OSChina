//
//  Utils.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD.h"


@implementation Utils

#pragma mark UI处理

+ (MBProgressHUD *)createHUD {

    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    return HUD;
}
@end
