//
//  RCDAddFriendCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/4.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCDUserInfo;
@interface RCDAddFriendCell : UITableViewCell

@property(nonatomic, strong)RCDUserInfo *userInfo;

@property(nonatomic, strong) UIImageView *headImage;

@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIButton *addButton;

@property(nonatomic, strong) UILabel *companyLabel;

@property(nonatomic, strong) UIView *separatorView;

@property(nonatomic, strong) UIView *bottomView;

@end
