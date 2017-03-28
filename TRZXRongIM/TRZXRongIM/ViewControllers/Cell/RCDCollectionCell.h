//
//  RCDCollectionCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 收藏视图
 */
@interface RCDCollectionCell : RCMessageCell

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UIImageView *pictureImage;

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
