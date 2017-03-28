//
//  RCDPublicProfileContentCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/16.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

typedef enum : NSUInteger {
    ProfileContentCellTypeIntroduction = 0,     //功能介绍
    ProfileContentCellTypeBody         = 1,     //账号主题
    ProfileContentCellTypeMobile       = 2,     //客服电话
} ProfileContentCellType;

/**
 公众号 信息内容cell
 */
@interface RCDPublicProfileContentCell : UITableViewCell

@property(nonatomic, assign)ProfileContentCellType type;
@property(nonatomic, strong) RCPublicServiceProfile *profile;

@end
