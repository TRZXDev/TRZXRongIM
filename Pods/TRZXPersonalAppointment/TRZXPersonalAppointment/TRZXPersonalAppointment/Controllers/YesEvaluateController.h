//
//  YesEvaluateController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PushSunGoBack @"PushSunGoBack"

@class UserFeedbackConroller;

@protocol zhuangtai1Delegate <NSObject>
- (void)push1ZhuangTai;
@end

/**
 *  已评价控制器
 */
@interface YesEvaluateController : UIViewController

@property (strong, nonatomic)UserFeedbackConroller *UserFeedbackVC;

@property (copy, nonatomic) NSString *mid;

@property (copy, nonatomic) NSString *superType;
@property (copy, nonatomic) NSString *zhuanjiaZT;

@property (copy, nonatomic) NSString *vipPDStr;

@property (copy, nonatomic) NSString *titleStr;

@property (nonatomic, weak) id<zhuangtai1Delegate>delegate;

@end
