//
//  SoftwareListVC.h
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCObjsViewController.h"

typedef NS_ENUM(NSUInteger, SoftwaresType) {
    SoftwaresTypeRecommended,
    SoftwaresTypeNewest,
    SoftwaresTypeHottest,
    SoftwaresTypeCN,
};

@interface SoftwareListVC : OSCObjsViewController

- (instancetype)initWithSoftwaresType:(SoftwaresType)softwareType;
- (instancetype)initWithSearchTag:(int)searchTag;

@end
