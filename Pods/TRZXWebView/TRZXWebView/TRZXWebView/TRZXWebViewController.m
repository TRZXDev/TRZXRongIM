//
//  TRZXWebViewController.m
//  TRZXWebViewController
//
//  Created by N年後 on 2017/2/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXWebViewController.h"
@interface TRZXWebViewController ()

@end

@implementation TRZXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationType = AXWebViewControllerNavigationToolItem;
    self.showsToolBar = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    self.webView.allowsLinkPreview = YES;
#endif

    [self loadURL:[NSURL URLWithString:self.webURL]];


    // Do any additional setup after loading the view.
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
