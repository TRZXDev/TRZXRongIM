//
//  ThemeViewController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ChuangJianZhuTiVC;
@class ThemeNoPassController;
@class ThemeViewController;
@interface MyThemeViewController : UIViewController

@property (strong, nonatomic)ChuangJianZhuTiVC *XiuGaiZhuTi;
//@property (strong, nonatomic)ThemeNoPassController *themeNoPass;
@property (strong, nonatomic)ThemeViewController *themeDetails;
@end
