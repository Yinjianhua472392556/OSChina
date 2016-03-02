//
//  LoginViewController.m
//  OSChina
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+Util.h"
#import "UIImage+FontAwesome.h"
#import "Config.h"
#import "ReactiveCocoa.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Utils.h"
#import "Ono.h"
#import "OSCUser.h"
#import "OSCThread.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *accountImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation LoginViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor themeColor];
    [self setUpSubviews];
    
    NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
    _accountField.text = accountAndPassword? accountAndPassword[0] : @"";
    _passwordField.text = accountAndPassword? accountAndPassword[1] : @"";
    RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
                                         reduce:^(NSString *account, NSString *password) {
                                             return @(account.length > 0 && password.length > 0);
                                         }];
    RAC(_loginButton, enabled) = valid;
    RAC(_loginButton, alpha) = [valid map:^(NSNumber *b) {
        return b.boolValue ? @1: @0.4;
    }];
    
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [_hud hide:YES];
}


#pragma mark - about subviews
- (void)setUpSubviews {

    _accountImageView.image = [UIImage imageWithIcon:@"fa-envelope-o" backgroundColor:[UIColor clearColor] iconColor:[UIColor grayColor] andSize:CGSizeMake(20, 20)];
    _passwordImageView.image = [UIImage imageWithIcon:@"fa-lock" backgroundColor:[UIColor clearColor] iconColor:[UIColor grayColor] andSize:CGSizeMake(20, 20)];
    
    _accountField.delegate = self;
    _passwordField.delegate = self;
    
    [_accountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (![_accountField isFirstResponder] && ![_passwordField isFirstResponder]) {
        return NO;
    }
    return YES;
}

#pragma mark - 键盘操作
- (void)hidenKeyboard {

    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender {

    if (sender == _accountField) {
        [_passwordField becomeFirstResponder];
    }else if (sender == _passwordField) {
    
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            [self login:nil];
        }
    }
}

- (IBAction)login:(id)sender {
    
    _hud = [Utils createHUD];
    _hud.labelText =  @"正在登录";
    _hud.userInteractionEnabled = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager OSCManager];
    [manager POST:[NSString stringWithFormat:@"%@%@",OSCAPI_PREFIX,OSCAPI_LOGIN_VALIDATE] parameters:@{@"username" : _accountField.text, @"pwd" : _passwordField.text, @"keep_login" : @(1)} success:^(AFHTTPRequestOperation * _Nonnull operation, ONOXMLDocument *responseObject) {
        
        ONOXMLElement *result = [responseObject.rootElement firstChildWithTag:@"result"];
        NSInteger errorCode = [[[result firstChildWithTag:@"errorCode"] numberValue] integerValue];
        if (!errorCode) {
            NSString *errorMessage = [[result firstChildWithTag:@"errorMessage"] stringValue];
            _hud.mode = MBProgressHUDModeCustomView;
            _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            _hud.labelText = [NSString stringWithFormat:@"错误：%@",errorMessage];
            [_hud hide:YES afterDelay:1];
            return ;
        }
        
        [Config saveOwnAccount:_accountField.text andPassword:_passwordField.text];
        ONOXMLElement *userXML = [responseObject.rootElement firstChildWithTag:@"user"];
        [self renewUserWithXML:userXML];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        MBProgressHUD *hud = [Utils createHUD];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        hud.labelText = [@(operation.response.statusCode) stringValue];
        hud.detailsLabelText = error.userInfo[NSLocalizedDescriptionKey];
        [hud hide:YES afterDelay:1];
    }];
    
}

- (void)renewUserWithXML:(ONOXMLElement *)xml {

    OSCUser *user = [[OSCUser alloc] initWithXML:xml];
    [Config saveOwnID:user.userID userName:user.name score:user.score favoriteCount:user.favoriteCount fansCount:user.fansCount andFollowerCount:user.followersCount];
    [OSCThread startPollingNotice];
    [self saveCookies];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*** 不知为何有时退出应用后，cookie不保存，所以这里手动保存cookie ***/
- (void)saveCookies {

    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cookiesData forKey:@"sessionCookies"];
    [defaults synchronize];
}

- (IBAction)loginFromQQ:(id)sender {
}
- (IBAction)loginFromWechat:(id)sender {
}
- (IBAction)loginFromWeibo:(id)sender {
}

@end
