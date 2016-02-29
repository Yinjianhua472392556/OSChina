//
//  Config.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSCMyInfo;

@interface Config : NSObject

+ (void)saveWhetherNightMode:(BOOL)isNight;
+ (BOOL)getMode;
+ (int64_t)getOwnID;
+ (NSArray *)getUsersInformation;
+ (UIImage *)getPortrait;
+ (NSString *)getOwnUserName;
+ (void)savePortrait:(UIImage *)portrait;
+ (void)updateMyInfo:(OSCMyInfo *)myInfo;

@end
