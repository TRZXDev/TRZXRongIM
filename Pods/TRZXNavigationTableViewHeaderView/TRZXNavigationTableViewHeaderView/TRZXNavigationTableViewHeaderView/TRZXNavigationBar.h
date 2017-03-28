//
//  TRZXProjectDetailNavigationView.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ENavigationBarAction_Back,
    ENavigationBarAction_Collect,
    ENavigationBarAction_Share,
} ENavigationBarAction;

@interface TRZXNavigationBar : UIView

/**
 导航标题
 */
@property (nonatomic, strong) NSString *title;

/**
 隐藏返回按钮
 */
@property (nonatomic, assign) BOOL backButtonHidden;

/**
 隐藏收藏按钮
 */
@property (nonatomic, assign) BOOL collectButtonHidden;

/**
 隐藏分享按钮
 */
@property (nonatomic, assign) BOOL shareButtonHidden;

/**
 设置分享按钮被选状态
 */
@property (nonatomic, assign) BOOL sharedButtonIsSelected;

/**
 导航栏个按钮点击事件回调
 */
@property (nonatomic, copy) void(^onNavigationBarActionBlock)(ENavigationBarAction action, UIButton *button);

/**
 改变导航栏及其子视图状态

 @param y contentOfset y
 */
- (void)makeNavigationBarIsShowWithContentOfsetY:(CGFloat)y;

@end
