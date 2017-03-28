//
//  WalletPayProtocolViewController.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/21.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "WalletPayProtocolViewController.h"
#import "TRZXWalletMacro.h"


@interface WalletPayProtocolViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *url;

@end

@implementation WalletPayProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerTitleLabe:@"投融在线快捷支付协议"];
    self.url = @"http://kipo-att-img.oss-cn-beijing.aliyuncs.com/arguement/%E6%8A%95%E8%9E%8D%E5%9C%A8%E7%BA%BF%E5%BF%AB%E6%8D%B7%E6%94%AF%E4%BB%98%E6%9C%8D%E5%8A%A1%E5%8D%8F%E8%AE%AE.pdf";
    self.view.backgroundColor = WalletbackColor;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height-65)];
    NSURL *url = [NSURL URLWithString:self.url];;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.webView setUserInteractionEnabled:YES];//是否支持交互
    //[webView setDelegate:self];
    self.webView.delegate=self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView setOpaque:NO];//opaque是不透明的意思
    [self.webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:self.webView];
}
- (void)goBackView:(UIButton *)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}
//屏蔽web的事件
- (void)webViewDidFinishLoad:(UIWebView*)theWebView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
