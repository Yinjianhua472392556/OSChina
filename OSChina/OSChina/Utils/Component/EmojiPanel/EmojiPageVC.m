//
//  EmojiPageVC.m
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EmojiPageVC.h"
#import "PlaceholderTextView.h"
#import "UIColor+Util.h"
#import "EmojiPanelVC.h"

@interface EmojiPageVC ()<UIPageViewControllerDataSource>
@property (nonatomic, copy) void (^didSelectEmoji) (NSTextAttachment *);
@property (nonatomic, copy) void (^deleteEmoji)();
@end

@implementation EmojiPageVC

- (instancetype)initWithTextView:(PlaceholderTextView *)textView {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (self) {
        _didSelectEmoji = ^(NSTextAttachment *textAttachment) {
        
            NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
            [mutableAttributeString replaceCharactersInRange:textView.selectedRange withAttributedString:emojiAttributedString];
            textView.attributedText = mutableAttributeString;
            textView.textColor = [UIColor titleColor];
            [textView insertText:@""];
            textView.font = [UIFont systemFontOfSize:16];
        };
        
        _deleteEmoji = ^{
            [textView deleteBackward];
        };
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:0];
    emojiPanelVC.didSelectEmoji = _didSelectEmoji;
    emojiPanelVC.deleteEmoji = _deleteEmoji;
    if (emojiPanelVC != nil) {
        self.dataSource = self;
        [self setViewControllers:@[emojiPanelVC] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(EmojiPanelVC *)viewController {

    int index = viewController.pageIndex;
    if (index == 0) {
        return nil;
    }else {
        EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:index -1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji = _deleteEmoji;
        return emojiPanelVC;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(EmojiPanelVC *)viewController {

    int index = viewController.pageIndex;
    if (index == 6) {
        return nil;
    }else {
    
        EmojiPanelVC *emojiPanelVC = [[EmojiPanelVC alloc] initWithPageIndex:index + 1];
        emojiPanelVC.didSelectEmoji = _didSelectEmoji;
        emojiPanelVC.deleteEmoji = _deleteEmoji;
        return emojiPanelVC;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 7;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {

    return 0;
}

@end
