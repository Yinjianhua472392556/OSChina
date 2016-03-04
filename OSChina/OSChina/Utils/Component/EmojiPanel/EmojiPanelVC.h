//
//  EmojiPanelVC.h
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiPanelVC : UIViewController

- (instancetype)initWithPageIndex:(int)pageIndex;
@property (nonatomic, assign, readonly) int pageIndex;
@property (nonatomic, copy) void (^didSelectEmoji) (NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end
