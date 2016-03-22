//
//  ImageViewerController.h
//  OSChina
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author 尹建华, 16-03-12 10:03:50
 *
 *  下载图片
 */
@interface ImageViewerController : UIViewController

- (instancetype)initWithImageURL:(NSURL *)imageURL;
- (instancetype)initWithImage:(UIImage *)image;

@end
