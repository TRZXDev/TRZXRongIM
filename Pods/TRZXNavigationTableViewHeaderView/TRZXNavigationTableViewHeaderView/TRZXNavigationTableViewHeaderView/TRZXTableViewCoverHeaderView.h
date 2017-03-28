//
//  TRZXProjectDetailTableViewHeaderView.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXNavigationBar.h"

@interface TRZXTableViewCoverHeaderView : UIView

/**
 初始化方法

 @param scrollView UIScrollView 或集成
 @return 返回 CoverHeaderView 实例
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

/**
 导航标题
 */
@property (nonatomic, strong) NSString *title;

/**
 coverImageUrl
 */
@property (nonatomic, strong) NSString *coverImageUrl;

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


- (void)addOwnViews;

- (void)layoutFrameOfSubViews;

- (void)receiveActions;

@end
