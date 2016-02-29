//
//  OSCMyInfo.h
//  OSChina
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCMyInfo : OSCBaseObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL *portraitURL;
@property (nonatomic, assign, readonly) int favoriteCount;
@property (nonatomic, assign, readonly) int fansCount;
@property (nonatomic, assign, readonly) int followersCount;
@property (nonatomic, assign, readonly) int score;
@property (nonatomic, assign, readonly) int gender;
@property (nonatomic, copy, readonly) NSString *joinTime;
@property (nonatomic, copy, readonly) NSString *developPlatform;
@property (nonatomic, copy, readonly) NSString *expertise;
@property (nonatomic, copy, readonly) NSString *hometown;

- (void)setDetailInformationJointime:(NSString *)jointime andHometown:(NSString *)hometown andDevelopPlatform:(NSString *)developPlatform andExpertise:(NSString *)expertise;

@end
