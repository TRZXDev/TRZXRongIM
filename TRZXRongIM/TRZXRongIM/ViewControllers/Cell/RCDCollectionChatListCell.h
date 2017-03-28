//
//  RCDCollectionChatListCell.h
//  TRZX
//
//  Created by 移动微 on 16/12/2.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 聚合显示 cell
 */
@interface RCDCollectionChatListCell : UITableViewCell

@property(nonatomic, strong) UIImageView *headImageView;

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UILabel *timeLabel;

-(void)setUnreadCount:(int)count;


@end
