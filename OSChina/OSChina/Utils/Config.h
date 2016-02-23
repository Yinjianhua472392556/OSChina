//
//  Config.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

+ (void)saveWhetherNightMode:(BOOL)isNight;
+ (BOOL)getMode;
+ (int64_t)getOwnID;
+ (NSArray *)getUsersInformation;
+ (UIImage *)getPortrait;
+ (NSString *)getOwnUserName;

@end
