//
//  CircleScrollView.h
//  ColloctionView循环滚动控件
//
//  Created by caokun on 16/1/28.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRZXShufflingView;

@interface TRZXShufflingView : UIView

/**
 *  点击广告页回调
 *
 *  @property index 点击的index
 */
@property (nonatomic, copy) void (^didClickImageAtIndexBlock)(NSInteger index); /**< 点击后的事件处理 */
@property (assign, nonatomic) NSTimeInterval duringTime;            // 间隔时间，0表示不自动滚动

- (void)images:(NSArray *)images;
- (void)closeTimer;
- (void)openTimer;

@end
