//
//  RCDSubscriptionResultCell.h
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCPublicServiceProfile;
/**
 搜索结果cell
 */
@interface RCDSubscriptionResultCell : UITableViewCell

/**
 公众号模型
 */
@property(nonatomic, strong) RCPublicServiceProfile *profile;

@end
