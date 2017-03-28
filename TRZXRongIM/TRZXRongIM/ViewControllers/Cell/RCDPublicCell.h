//
//  RCDPublicCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 公众号
 */
@interface RCDPublicCell : RCMessageCell


/**
 名片标题
 */
@property(nonatomic, strong) UILabel *nameLabel;

/**
 图片
 */
@property(nonatomic, strong) UIImageView *iconImageView;

/**
 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@property(nonatomic, strong) UILabel *promptLabel;

@property(nonatomic, strong) UIView *separatorView;


/**
 设置消息数据模型
 
 @param model 消息数据模型
 */
-(void)setDataModel:(RCMessageModel *)model;

@end
