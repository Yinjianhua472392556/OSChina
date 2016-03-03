//
//  OSLicensePage.m
//  OSChina
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSLicensePage.h"

@interface OSLicensePage ()

@end

@implementation OSLicensePage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开源组件";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scrollView.bounces = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"OSLicense" ofType:@"html"]]]];
    [self.view addSubview:webView];
}


@end
