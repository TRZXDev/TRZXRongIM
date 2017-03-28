//
//  DynamicGraphicCell.h
//  TRZX
//
//  Created by 张江威 on 2016/10/27.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DynamicHomeModel;

@interface DynamicGraphicCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;


@property (nonatomic, strong) UIImageView *likeImage;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UILabel *shareLable;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel * lineLab;

@property (nonatomic, strong) DynamicHomeModel *model;



@end
