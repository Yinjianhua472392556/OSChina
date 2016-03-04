//
//  BottomBarViewController.h
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingBar.h"
#import "OperationBar.h"

@class EmojiPageVC;

@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) EditingBar *editingBar;
@property (nonatomic, strong) OperationBar *operationBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;


- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;
- (void)sendContent;
- (void)updateInputBarHeight;
- (void)hideEmojiPageView;

@end
