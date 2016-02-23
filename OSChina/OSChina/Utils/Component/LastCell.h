//
//  LastCell.h
//  OSChina
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LastCellStatus) {
    LastCellStatusNotVisible,
    LastCellStatusMore,
    LastCellStatusLoading,
    LastCellStatusError,
    LastCellStatusFinished,
    LastCellStatusEmpty,
};

@interface LastCell : UIView

@property (nonatomic, assign) LastCellStatus status;
@property (nonatomic, assign,readonly) BOOL shouldResponseToTouch;
@property (nonatomic, copy) NSString *emptyMessage;
@property (nonatomic, strong) UILabel *textLabel;

@end
