//
//  RCDBusinessCardCell.h
//  TRZX
//
//  Created by 移动微 on 16/10/29.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>


#define RCDBusinessCardCellKey @"RCDBusinessCardCellKey"
/**
 名片消息类
 */
@interface RCDBusinessCardCell : RCMessageCell

/**
 名片标题
 */
@property(nonatomic, strong) UILabel *nameLabel;

/**
 名片签名
 */
@property(nonatomic, strong) UILabel *signatureLabel;

@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) UILabel *promptLabel;

@property(nonatomic, strong) UIView *separatorView;

/**
 消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 设置消息数据模型

 @param model 消息数据模型
 */
-(void)setDataModel:(RCMessageModel *)model;

@end
