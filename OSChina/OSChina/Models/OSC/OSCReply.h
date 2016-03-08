//
//  OSCReply.h
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCReply : OSCBaseObject<NSCopying>
@property (nonatomic, copy, readonly) NSString *author;
@property (nonatomic, copy, readonly) NSString *pubDate;
@property (nonatomic, copy, readonly) NSString *content;
@end
