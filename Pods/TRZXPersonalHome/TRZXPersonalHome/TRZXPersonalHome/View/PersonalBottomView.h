//
//  PersonalBottomView.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/12.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXPersonalNModel.h"

//@class PersonalModell;
@interface PersonalBottomView : UIView
@property (strong, nonatomic)  UIButton *sixinBtn;
@property (strong, nonatomic)  UIButton *BPButton;
@property (strong, nonatomic)  UIButton *guanzhuBtn;

@property(nonatomic,strong) personalData *model;

// 关注点击
-(void)guanzhuBtnStatusChange;

@end
