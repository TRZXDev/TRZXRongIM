//
//  PersonalJiaoYiTabCell.h
//  TRZX
//
//  Created by 张江威 on 16/8/30.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DVSwitch/DVSwitch.h>

@interface PersonalJiaoYiTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *qiyeView;
@property (weak, nonatomic) IBOutlet UIView *zhiboView;

@property(nonatomic, strong)DVSwitch *switcher;

@end
