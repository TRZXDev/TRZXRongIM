//
//  RCDRedPacketsCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
/**
 红包消息视图
 */
@interface RCDRedPacketsCell : RCMessageCell

/**
 标题
 */
@property(nonatomic, strong) UILabel *titleLabel;

/**
 内容
 */
@property(nonatomic, strong) UILabel *contentLabel;

/**
 背景图片
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 设置消息数据模型
 
 @param model 消息数据模型
 */
-(void)setDataModel:(RCMessageModel *)model;

@end
