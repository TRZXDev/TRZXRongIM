//
//  TRZXPShareDeleViewController.m
//  TRZX
//
//  Created by 张江威 on 2017/1/14.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import "TRZXPShareDeleViewController.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXPShareDeleViewController ()

@end

@implementation TRZXPShareDeleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内容已删除";
    self.view.backgroundColor = backColor;
    
    UIImageView * bgdImage = [[UIImageView alloc]init];
    bgdImage.image = [UIImage imageNamed:@"PersonalShareDelle"];
    bgdImage.frame = CGRectMake(0, 0, SCREEN_WIDTH-160, ((SCREEN_WIDTH-160)*312)/358);
    bgdImage.center = self.view.center;
    [self.view addSubview:bgdImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
