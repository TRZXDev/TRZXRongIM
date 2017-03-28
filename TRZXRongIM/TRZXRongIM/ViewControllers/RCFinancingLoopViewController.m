//
//  RCFinancingLoopViewController.m
//  TRZX
//
//  Created by 移动微 on 16/6/8.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCFinancingLoopViewController.h"
#import "RCDCommonDefine.h"

@interface RCFinancingLoopViewController ()

@end

@implementation RCFinancingLoopViewController

#pragma mark - 视图的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [self.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = image;
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.view.backgroundColor = [UIColor trzx_BackGroundColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationColor];
}

-(void)setNavigationColor{
    self.tabBarController.navigationItem.title = @"投融圈";
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
//    UIFont *font = [UIFont boldSystemFontOfSize:19.f];
//    NSDictionary *textAttributes = @{
//                                     NSFontAttributeName : font,
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     };
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
