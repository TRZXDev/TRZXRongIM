//
//  ShareDeleViewController.m
//  TRZX
//
//  Created by 张江威 on 2017/1/14.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import "ShareDeleViewController.h"

#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@interface ShareDeleViewController ()

@end

@implementation ShareDeleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内容已删除";
    self.view.backgroundColor = backColor;
    
    UIImageView * bgdImage = [[UIImageView alloc]init];
    bgdImage.image = [UIImage imageNamed:@"发布分享删除图标"];
    //    _bgdImage.contentMode =  UIViewContentModeScaleAspectFill;358  312
    bgdImage.frame = CGRectMake(0, 0, SCREEN_WIDTH-160, ((SCREEN_WIDTH-160)*312)/358);
    bgdImage.center = self.view.center;
    [self.view addSubview:bgdImage];
//    UILabel * lab = [[UILabel alloc]init];
//    lab.text = @"内容已删除";
//    lab.frame = CGRectMake(0, (SCREEN_HEIGHT-(SCREEN_WIDTH*312)/358)/2+140, SCREEN_WIDTH, 30);
//    lab.font = [UIFont systemFontOfSize:15];
//    lab.textColor = zideColor;
//    lab.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:lab];
    
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
