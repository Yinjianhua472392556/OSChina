//
//  OSCThread.m
//  OSChina
//
//  Created by apple on 16/3/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCThread.h"
#import "Reachability.h"
#import "AFHTTPRequestOperationManager+Util.h"
#import "Config.h"
#import "Ono.h"

static BOOL isPollingStarted;
static NSTimer *timer;
static Reachability *reachability;

@implementation OSCThread

+ (void)startPollingNotice {

    if (isPollingStarted) {
        return;
    }else {
    
        timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        reachability = [Reachability reachabilityWithHostName:@"www.oschina.net"];
        isPollingStarted = YES;
    }
}

+ (void)timerUpdate {
    if (reachability.currentReachabilityStatus == 0) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    [manager GET:[NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_USER_NOTICE] parameters:@{@"uid" : @([Config getOwnID])} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
        ONOXMLElement *notice = [responseObject.rootElement firstChildWithTag:@"notice"];
        int atCount = [[[notice firstChildWithTag:@"atmeCount"] numberValue] intValue];
        int msgCount = [[[notice firstChildWithTag:@"msgCount"] numberValue] intValue];
        int reviewCount = [[[notice firstChildWithTag:@"reviewCount"] numberValue] intValue];
        int newFansCount = [[[notice firstChildWithTag:@"newFansCount"] numberValue] intValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:OSCAPI_USER_NOTICE object:@[@(atCount), @(reviewCount), @(msgCount), @(newFansCount)]];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
