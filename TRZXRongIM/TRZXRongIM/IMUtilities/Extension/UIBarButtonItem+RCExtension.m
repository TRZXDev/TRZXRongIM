//
//  UIBarButtonItem+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UIBarButtonItem+RCExtension.h"
#import "RCDCommonDefine.h"

@implementation UIBarButtonItem (RCExtension)

//// 构造函数1 创建 UIBarButtonItem
+(instancetype)RC_barButtonWithTitle:(NSString *)title color:(UIColor *)color imageName:(NSString *)imageName target:(id)target action:(SEL)action{
    UIButton *button = [UIButton RC_buttonWithTitle:title color:color imageName:imageName target:target action:action];
    button.frame = CGRectMake(0, 8, 50, 23);
    [button sizeToFit];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

/// 返回按钮  返回字体的颜色的  + 图片的颜色样式
+(instancetype)RC_LeftTarButtonItemDefaultTarget:(id)target titelabe:(NSString *)tittStr color:(UIColor *)color action:(SEL)action{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 8, 50, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage RC_BundleImgName:tittStr]];
    backImg.frame = CGRectMake(-5, 3, 10, 16);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 85, 22)];
    backText.text = @"返回";
    backText.font = [UIFont systemFontOfSize:16];//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
    [backText setTextColor:color];
    [backBtn addSubview:backText];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return leftButton;
}

+(instancetype)RC_RightButtonItemWithImageName:(NSString *)imageName Target:(id)target action:(SEL)action{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 8, 50, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage RC_BundleImgName:imageName]];
    backImg.frame = CGRectMake(35, 5, 15, 20);
    [backBtn addSubview:backImg];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    return rightButton;
}

+(instancetype)RC_RightButtonItemWithImageName:(NSString *)imageName buttonRect:(CGRect)buttonRect imageRect:(CGRect)imageRect Target:(id)target action:(SEL)action{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = buttonRect;
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage RC_BundleImgName:imageName]];
    backImg.frame = imageRect;
    [backBtn addSubview:backImg];
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    return rightButton;
}

@end
