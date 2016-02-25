//
//  OSCSoftware.h
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCSoftware : OSCBaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *softwareDescription;
@property (nonatomic, copy) NSURL *url;

@end
