//
//  OSCComment.h
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"
#import "OSCReference.h"
#import "OSCReply.h"
#import "TeamMember.h"


@interface OSCComment : OSCBaseObject

@property (nonatomic, assign) int64_t commentID;
@property (nonatomic, copy) NSURL *portraitURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) int64_t authorID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pubDate;
@property (nonatomic, assign) int appclient;
@property (nonatomic, strong) NSArray *references;
@property (nonatomic, strong) NSArray *replies;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) TeamMember *teamMember;

- (instancetype)initWithReplyXML:(ONOXMLElement *)xml;
+ (NSAttributedString *)attributedTextFromReplies:(NSArray *)replies;

@end
