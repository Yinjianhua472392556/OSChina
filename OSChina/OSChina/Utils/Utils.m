//
//  Utils.m
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Utils.h"
#import "MBProgressHUD.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import <GRMustache/GRMustache.h>


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

#pragma mark 信息处理

+ (NSAttributedString *)attributedCommentCount:(int)commentCount {

    NSString *rawString = [NSString stringWithFormat:@"%@ %d", [NSString fontAwesomeIconStringForEnum:FACommentsO], commentCount];
    NSAttributedString *attributedCommentCount = [[NSAttributedString alloc] initWithString:rawString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    return attributedCommentCount;
}

+ (NSAttributedString *)emojiStringFromRawString:(NSString *)rawString {

    NSMutableAttributedString *emojiString = [[NSMutableAttributedString alloc] initWithString:rawString];
    NSDictionary *emoji = self.emojiDict;
    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]|:[a-zA-Z0-9\\u4e00-\\u9fa5_]+:";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultsArray = [re matchesInString:rawString options:0 range:NSMakeRange(0, rawString.length)];
    NSMutableArray *emojiArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
    
    for (NSTextCheckingResult *match in resultsArray) {
        NSRange range = [match range];
        NSString *emojiName = [rawString substringWithRange:range];
        if ([emojiName hasPrefix:@"["] && emoji[emojiName]) {
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:emoji[emojiName]];
            [textAttachment adjustY:-3];
            
            NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [emojiArray addObject:@{@"image" : emojiAttributedString, @"range" : [NSValue valueWithRange:range]}];
        }else if ([emojiName hasPrefix:@":"]) {
            if (emoji[emojiName]) {
                [emojiArray addObject:@{@"text" : emoji[emojiName], @"range" : [NSValue valueWithRange:range]}];
            }else {
            
                UIImage *emojiImage = [UIImage imageNamed:[emojiName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]]];
                NSTextAttachment *textAttachment = [NSTextAttachment new];
                textAttachment.image = emojiImage;
                [textAttachment adjustY:-3];
                
                NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [emojiArray addObject:@{@"image": emojiAttributedString, @"range": [NSValue valueWithRange:range]}];
            }
        }
    }
    for (NSInteger i = emojiArray.count - 1; i >= 0 ; i--) {
        NSRange range;
        [emojiArray[i][@"range"] getValue:&range];
        if (emojiArray[i][@"image"]) {
            [emojiString replaceCharactersInRange:range withAttributedString:emojiArray[i][@"image"]];
        }else {
        
            [emojiString replaceCharactersInRange:range withString:emojiArray[i][@"text"]];
        }
    }
    
    return emojiString;
}

+ (NSDictionary *)emojiDict {
    static NSDictionary *emojiDict;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"emoji" ofType:@"plist"];
        emojiDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    });
    return emojiDict;
}

+ (NSAttributedString *)attributedTimeString:(NSString *)dateStr {

    NSString *rawString = [NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAClockO], [self intervalSinceNow:dateStr]];
    NSAttributedString *attributedTime = [[NSAttributedString alloc] initWithString:rawString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    return attributedTime;
}

+ (NSString *)intervalSinceNow:(NSString *)dateStr {

    NSDictionary *dic = [Utils timeIntervalArrayFromString:dateStr];
    NSInteger months = [[dic objectForKey:kKeyMonths] integerValue];
    NSInteger days = [[dic objectForKey:kKeyDays] integerValue];
    NSInteger hours = [[dic objectForKey:kKeyHours] integerValue];
    NSInteger minutes = [[dic objectForKey:kKeyMinutes] integerValue];
    
    if (minutes < 1) {
        return @"刚刚";
    }else if (minutes < 60) {
    
        return [NSString stringWithFormat:@"%ld分钟前",minutes];
    }else if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }else if (hours < 48 && days == 1) {
    
        return @"昨天";
    }else if (days < 30) {
    
        return [NSString stringWithFormat:@"%ld天前",days];
    }else if (days < 60) {
    
        return @"一个月前";
    }else if (months < 12) {
    
        return [NSString stringWithFormat:@"%ld个月前",months];
    }else {
        NSArray *arr = [dateStr componentsSeparatedByString:@" "];
        return arr[0];
    }
}

+ (NSDictionary *)timeIntervalArrayFromString:(NSString *)dateStr {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *compsPast = [calendar components:unitFlags fromDate:date];
    NSDateComponents *compsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger daysInLastMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    NSInteger years = [compsNow year] - [compsPast year];
    NSInteger months = [compsNow month] - [compsPast month] + years * 12;
    NSInteger days = [compsNow day] - [compsPast day] + months * daysInLastMonth;
    NSInteger hours = [compsNow hour] - [compsPast hour] + days * 24;
    NSInteger minutes = [compsNow minute] - [compsPast minute] + hours * 60;
    return @{kKeyYears : @(years) ,kKeyMonths : @(months), kKeyDays : @(days), kKeyHours : @(hours),kKeyMinutes : @(minutes)};
}

#pragma mark - 处理API返回信息
+ (NSAttributedString *)getAppclient:(int)clientType {
    NSMutableAttributedString *attributedClientString;
    if (clientType > 1 && clientType <=6) {
        NSArray *clients = @[@"", @"", @"手机", @"Android", @"iPhone", @"Windows Phone", @"微信"];
        attributedClientString = [[NSMutableAttributedString alloc] initWithString:[NSString fontAwesomeIconStringForEnum:FAMobile] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
        [attributedClientString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",clients[clientType]]]];
    }else {
    
        attributedClientString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return attributedClientString;
}

+ (BOOL)isNetworkExist {

    return [self networkStatus] > 0;
}

+ (NSInteger)networkStatus {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.oschina.net"];
    return reachability.currentReachabilityStatus;
}

+ (UIImage *)createQRCodeFromString:(NSString *)string {

    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGFloat scale = 5;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:QRFilter.outputImage fromRect:QRFilter.outputImage.extent];
    
    //Scale the image usign CoreGraphics
    CGFloat width = QRFilter.outputImage.extent.size.width * scale;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return image;
}

+ (NSString *)escapeHTML:(NSString *)originalHTML {

    if (!originalHTML) {
        return @"";
    }
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:originalHTML];
    [result replaceOccurrencesOfString:@"&" withString:@"&amp" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"<" withString:@"&lt" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@"'"  withString:@"&#39;"  options:NSLiteralSearch range:NSMakeRange(0, [result length])];
    return result;
}

+ (NSString *)generateRelativeNewsString:(NSArray *)relativeNews {

    if (relativeNews == nil || relativeNews.count == 0) {
        return @"";
    }
    
    NSString *middle = @"";
    for (NSArray *news in relativeNews) {
        middle = [NSString stringWithFormat:@"%@<a href=%@ style='text-decoration:none'>%@</a><p/>",middle,news[1],news[0]];
    }
    return [NSString stringWithFormat:@"相关文章<div style='font-size:14px'><p/>%@</div>",middle];
}

+ (NSString *)HTMLWithData:(NSDictionary *)data usingTemplate:(NSString *)templateName {

    NSString *templatePath = [[NSBundle mainBundle] pathForResource:templateName ofType:@"html"];
    NSString *template = [NSString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableDictionary *mutableData = [data mutableCopy];
    [mutableData setObject:@(((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode) forKey:@"night"];
    return [GRMustacheTemplate renderObject:mutableData fromString:template error:nil];
}

+ (NSString *)deleteHTMLTag:(NSString *)HTML {

    NSMutableString *trimmedHTML = [[NSMutableString alloc] initWithString:HTML];
    NSString *styleTagPattern = @"<style[^>]*?>[\\s\\S]*?<\\/style>";
    NSRegularExpression *styleTagRe = [NSRegularExpression regularExpressionWithPattern:styleTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultsArray = [styleTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    NSString *htmlTagPattern = @"<[^>]+>";
    NSRegularExpression *normalHTMLTagRe = [NSRegularExpression regularExpressionWithPattern:htmlTagPattern options:NSRegularExpressionCaseInsensitive error:nil];
    resultsArray = [normalHTMLTagRe matchesInString:trimmedHTML options:0 range:NSMakeRange(0, trimmedHTML.length)];
    for (NSTextCheckingResult *match in [resultsArray reverseObjectEnumerator]) {
        [trimmedHTML replaceCharactersInRange:match.range withString:@""];
    }
    
    return trimmedHTML;
}




@end
