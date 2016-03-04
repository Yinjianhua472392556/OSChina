//
//  EditingBar.h
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"

@interface EditingBar : UIToolbar

@property (nonatomic, strong) GrowingTextView *editView;
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) UIButton *inputViewButton;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
