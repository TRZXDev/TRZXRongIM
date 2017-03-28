//
//  ViewController.m
//  TRZXRongIM
//
//  Created by 移动微 on 17/3/2.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "ViewController.h"
#import "RCDChatListViewController.h"
#import "Target_TRZXRongIM.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self button];
}

- (void)buttonDidClick:(UIButton *)button{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[Target_TRZXRongIM alloc] Action_RCDChatListViewController:@{@"vcTitle":@" 私信"}]];
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _button.center = self.view.center;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"Enter" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_button];
        
    }
    return _button;
}


@end
