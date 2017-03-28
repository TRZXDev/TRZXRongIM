//
//  RCNewImagePickerController.m
//  TRZX
//
//  Created by 移动微 on 16/6/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCNewImagePickerController.h"
#import "UIBarButtonItem+RCExtension.h"

@interface RCNewImagePickerController ()

@end

@implementation RCNewImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1] action:@selector(leftBarButtonItemPressed:)];
    self.navigationController.navigationItem.rightBarButtonItem = nil;

    [self.navigationItem setRightBarButtonItem:nil];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    [[UINavigationBar appearance].backItem setRightBarButtonItem:rightButton];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    

}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
