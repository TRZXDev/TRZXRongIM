//
//  Target_TRZXPersonalHome.h
//  TRZXPersonalHome
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Target_TRZXPersonalHome : NSObject

- (UIViewController *)Action_PersonalHomeViewController:(NSDictionary *)params;

/**
 我的收藏
 
 @param params ..
 @return ..
 */
- (UIViewController *)Action_CollectionViewController:(NSDictionary *)params;

/**
 关于我

 @param title 标题
 @param eduArray 教育经历
 @param workArr 工作经理
 @param type 用户类型
 @param abstract 个人简介
 @return //
 */
+ (UIViewController *)Action_PersonalProfileViewControllerTitle:(NSString *)title eduArr:(NSArray *)eduArray workArr:(NSArray *)workArr userType:(NSString *)type abstract:(NSString *)abstract;


/**
 我的钱包

 @param params ..
 @return ..
 */
+ (UIViewController *)Action_MyWalletViewController:(NSDictionary *)params;


///**
// 我的客户
//
// @param params ..
// @return ..
// */
//+ (UIViewController *)Action_MyCustomerViewController:(NSDictionary *)params;

/**
 客服中心
 
 @return ..
 */
+ (UIViewController *)Action_TRZXCustomerCenterController;

/**
 我的专家
 
 @return ..
 */
+ (UIViewController *)Action_PersonalAppointment_MyExpertViewController;

/**
 我的学员
 
 @return ..
 */
+ (UIViewController *)Action_PersonalAppointment_MyStudensController;
/**
 我的主题
 
 @return ..
 */
+ (UIViewController *)Action_MyTheme_MyThemeViewController;

/**
 相册
 
 @return ..
 */
+ (UIViewController *)FriendCircle_PhotoTimeLineTableViewController;

@end
