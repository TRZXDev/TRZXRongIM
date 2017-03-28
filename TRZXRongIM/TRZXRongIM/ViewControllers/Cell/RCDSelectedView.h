//
//  RCDSelectedView.h
//  TRZX
//
//  Created by 移动微 on 16/9/5.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , RCDSelectedViewType) {
    RCDSelectedViewTypeAddressBook    = 0,     //通讯录
    RCDSelectedViewTypeFinancingLoop  = 1,   //投融圈
    RCDSelectedViewTypeSubscribe      = 2,       //订阅刊
    RCDSelectedViewTypeAnnouncement,    //公告
};

@interface RCDSelectedView : UIView

@property(nonatomic,copy)void(^buttonDidClickBlock)(RCDSelectedViewType);

+(instancetype)initWithType:(RCDSelectedViewType)type;

@property(nonatomic,assign)RCDSelectedViewType type;

@property(nonatomic,strong)UILabel *badgeNumberLabel;

@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIView *redView;

/*!
 设置角标的值
 
 @param msgCount 角标值
 */
- (void)setBubbleTipNumber:(int)msgCount;

-(void)redViewHidden:(BOOL)Bool;

@end
