//
//  Config.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Config.h"
#import "OSCMyInfo.h"
#import <SSKeychain/SSKeychain.h>

NSString * const kService = @"OSChina";
NSString * const kAccount = @"account";
NSString * const kUserID = @"userID";

NSString * const kUserName = @"name";
NSString * const kPortrait = @"portrait";
NSString * const kUserScore = @"score";
NSString * const kFavoriteCount = @"favoritecount";
NSString * const kFanCount = @"fans";
NSString * const kFollowerCount = @"followers";

NSString * const kJointime = @"jointime";
NSString * const kDevelopPlatform = @"devplatform";
NSString * const kExpertise = @"expertise";
NSString * const kHometown = @"from";

NSString * const kTrueName = @"trueName";
NSString * const kSex = @"sex";
NSString * const kPhoneNumber = @"phoneNumber";
NSString * const kCorporation = @"corporation";
NSString * const kPosition = @"position";

NSString * const kTeamID = @"teamID";
NSString * const kTeamsArray = @"teams";


@implementation Config

+(BOOL)getMode {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

+ (void)saveWhetherNightMode:(BOOL)isNight {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(isNight) forKey:@"mode"];
    [userDefaults synchronize];
}
+ (int64_t)getOwnID {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userID = [userDefaults objectForKey:kUserID];
    if (userID) {
        return [userID longLongValue];
    }
    return 0;
}

+ (NSArray *)getUsersInformation {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:kUserName];
    NSNumber *score = [userDefaults objectForKey:kUserScore];
    NSNumber *favoriteCount = [userDefaults objectForKey:kFavoriteCount];
    NSNumber *fans = [userDefaults objectForKey:kFanCount];
    NSNumber *follower = [userDefaults objectForKey:kFollowerCount];
    NSNumber *userID = [userDefaults objectForKey:kUserID];

    if (userName) {
        return @[userName,score,favoriteCount,follower,fans,userID];
    }
    return @[@"点击头像登录", @(0), @(0), @(0), @(0), @(0)];
}

+ (void)saveOwnID:(int64_t)userID userName:(NSString *)userName score:(int)score favoriteCount:(int)favoriteCount fansCount:(int)fanCount andFollowerCount:(int)followerCount {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(userID) forKey:kUserID];
    [userDefaults setObject:userName forKey:kUserName];
    [userDefaults setObject:@(score) forKey:kUserScore];
    [userDefaults setObject:@(favoriteCount) forKey:kFavoriteCount];
    [userDefaults setObject:@(fanCount) forKey:kFanCount];
    [userDefaults setObject:@(followerCount) forKey:kFollowerCount];
    [userDefaults synchronize];
}

+ (UIImage *)getPortrait {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIImage *portrait  = [UIImage imageWithData:[userDefaults objectForKey:kPortrait]];
    return portrait;
}


+ (NSString *)getOwnUserName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:kUserName];
    if (userName) {
        return userName;
    }
    return @"";
}

+ (void)savePortrait:(UIImage *)portrait {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:UIImagePNGRepresentation(portrait) forKey:kPortrait];
    [userDefaults synchronize];
}

+ (void)updateMyInfo:(OSCMyInfo *)myInfo {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:myInfo.name forKey:kUserName];
    [userDefaults setObject:@(myInfo.score) forKey:kUserScore];
    [userDefaults setObject:@(myInfo.favoriteCount) forKey:kFavoriteCount];
    [userDefaults setObject:@(myInfo.fansCount)      forKey:kFanCount];
    [userDefaults setObject:@(myInfo.followersCount) forKey:kFollowerCount];
    [userDefaults synchronize];

}

+ (NSArray *)getOwnAccountAndPassword {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDefaults objectForKey:kAccount];
    NSString *password = [SSKeychain passwordForService:kService account:account];
    if (account) {
        return @[account, password];
    }
    
    return nil;
}

+ (void)saveOwnAccount:(NSString *)account andPassword:(NSString *)password {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:kAccount];
    [userDefaults synchronize];
    [SSKeychain setPassword:password forService:kService account:account];
}

+ (void)removeTeamInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kTeamID];
    [userDefaults removeObjectForKey:kTeamsArray];
}

+ (void)clearCookie {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"sessionCookies"];
}

@end
