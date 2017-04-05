//
//  RCDPublicWebViewController.m
//  TRZX
//
//  Created by 移动微 on 17/1/8.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import "RCDPublicWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RCDPublicServiceProfileViewController.h"
#import "RCDCommonDefine.h"


@interface RCDPublicWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) JSContext *context;

@property (nonatomic, strong) UIView *opaqueView;

@property (nonatomic, assign) NSString *currentURL;



@property (nonatomic, strong) UIImageView *tempImage;

@end

@implementation RCDPublicWebViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"collection_share" buttonRect:CGRectMake(0, 8, 50, 23) imageRect:CGRectMake(35, 5, 18, 20) Target:self action:@selector(rightBarButtomItemPressed:)];

    NSURL *url = [NSURL URLWithString:self.webURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - Action
-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtomItemPressed:(UIButton *)button{
    NSLog(@"分享");
    
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title= self.title?:@"";
    msg.desc= self.desc?:@"";
    msg.link= self.currentURL;
    msg.image=self.tempImage.image?:[UIImage RC_BundleImgName:@"展位图"];//缩略图
    msg.headURL = self.headURL?:self.profile.portraitUrl;
    // 袁超定的规则
//    viewUrl+"---"+public_service_id+"---"+public_name+"---"+public_img+"---"+public_content
    msg.objId = [NSString stringWithFormat:@"%@---%@---%@---%@---%@",self.webURL,self.profile.publicServiceId,self.profile.name,self.profile.portraitUrl,self.profile.introduction];
    msg.type= @"publicWeb"; // 分享类型
    
    [[TRZXShareManager sharedManager] showTRZXShareViewMessage:msg handler:^(TRZXShareType type) {
        
    }];
}

#pragma mark - UIWebViewDelegate
/**
 WebView 开始加载
 */
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityView startAnimating];
    self.opaqueView.hidden = NO;
}

/**
 WebView 加载失败
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityView stopAnimating];
    self.opaqueView.hidden = YES;
}

/**
 WebView 加载完成
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityView stopAnimating];
    self.opaqueView.hidden = YES;
    self.currentURL = webView.request.URL.absoluteString;
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 打印异常
    [self.context setExceptionHandler:^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"%@",exceptionValue);
    }];
    
    NSString *jsScript = @"document.title";
    NSString *title = [self.context evaluateScript:jsScript].toString;
    self.title = title;
    
    // 操作JS
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "var child=document.getElementsByTagName('a')[0];"
     "child.onclick=function(){"
     "    userIdClick();"
     "};"
     "function userIdClick(){ "
     "    console.log('点击了userId')"
     "};"
     ];
    
    NSString *jsScript1 = @"document.getElementsByTagName('img')[0].src";
    NSString *headURLValue = [[self.context evaluateScript:jsScript1] toString];
    if (headURLValue.length || ![headURLValue isEqualToString:@"undefined"]) {
        if(self.headURL.length == 0){
            self.headURL = [[self.context evaluateScript:jsScript1] toString];
        }
    }
    [self.tempImage sd_setImageWithURL:[NSURL URLWithString:self.headURL?:self.profile.portraitUrl]];
    
    NSString *jsScript2 = @"document.getElementsByTagName('p')[1].innerHTML";
    if(![[[self.context evaluateScript:jsScript2] toString] containsString:@"</a>"]){
        if (self.desc.length == 0) {
            self.desc = [[self.context evaluateScript:jsScript2] toString];
            self.desc = [self.desc stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        }
    }
    
    __weak __typeof(self) sfself = self;
    self.context[@"userIdClick"] =
    ^()
    {
        [sfself pushProfileViewController];
    };
}

-(void)pushProfileViewController{
    dispatch_async(dispatch_get_main_queue(), ^{        
        RCDPublicServiceProfileViewController *profileVC = [[RCDPublicServiceProfileViewController alloc] init];
        profileVC.profile = self.profile;
        [self.navigationController pushViewController:profileVC animated:YES];
    });
}

#pragma mark - Properties
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.userInteractionEnabled = YES;
        _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_webView setScalesPageToFit:YES];
        [_webView setOpaque:NO];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _webView;
}

-(UIView *)opaqueView{
    if (!_opaqueView) {
        _opaqueView = [UIView RC_viewWithColor:[UIColor blackColor]];
        [_opaqueView setAlpha:0.6];
        [self.webView addSubview:_opaqueView];
        [_opaqueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.webView);
            make.right.equalTo(self.webView);
            make.top.equalTo(self.webView);
            make.bottom.equalTo(self.webView);
        }];
    }
    return _opaqueView;
}

-(UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        _activityView.color = _activityView.tintColor = [UIColor blackColor];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.opaqueView addSubview:self.activityView];
        [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.opaqueView);
            make.left.equalTo(self.opaqueView);
            make.right.equalTo(self.opaqueView);
            make.bottom.equalTo(self.opaqueView);
        }];
    }
    return _activityView;
}
-(UIImageView *)tempImage{
    if (!_tempImage) {
        _tempImage = [[UIImageView alloc] initWithImage:[UIImage RC_BundleImgName:@"展位图"]];
        _tempImage.frame = CGRectMake(0, 0, 100, 100);
    }
    return _tempImage;
}
@end
