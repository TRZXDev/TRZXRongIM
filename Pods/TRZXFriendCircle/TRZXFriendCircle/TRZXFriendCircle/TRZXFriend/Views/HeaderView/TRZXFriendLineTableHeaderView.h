//
//  TRZXFriendLineTableHeaderView.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.

#import <UIKit/UIKit.h>
#import "TRZXFriendLineCellModel.h"

@interface TRZXFriendLineTableHeaderView : UIView


@property (nonatomic, strong) TRZXFriendLineCellModel *model;

//@property (nonatomic, assign, getter = isMessage) BOOL newMessage;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;


@end
