//
//  OSCSoftwareCatalog.h
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface OSCSoftwareCatalog : OSCBaseObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) int tag;

@end
