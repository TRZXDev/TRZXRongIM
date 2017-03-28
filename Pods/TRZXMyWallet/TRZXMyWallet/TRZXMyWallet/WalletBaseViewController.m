//
//  WalletBaseViewController.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/21.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "WalletBaseViewController.h"
#import "Masonry.h"
#import "TRZXWalletMacro.h"

@interface WalletBaseViewController ()

@end

@implementation WalletBaseViewController

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self addLeftWithTitle:@"返回"];
}

- (void)registerTitleLabe:(NSString *)title{
    self.title = title;
    
}
//添加返回按钮
- (void)addLeftWithTitle:(NSString *)title{
    if (self.navigationController.viewControllers.count < 2) {
        return;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 28);
    [btn setImage:[UIImage imageNamed:@"white_Back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitleColor:WalletzideColor forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn sizeToFit];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    self.navigationItem.leftBarButtonItems = @[space,back];
}

//返回上一页
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
