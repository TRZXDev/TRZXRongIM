//
//  TRZXProjectDeatilCommentOfOneTableViewCell.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/4.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRZXProjectDetailCommentModel;

@interface TRZXProjectDetailCommentOfOneView : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *sendCommentTimeLabel;

@property (nonatomic, strong) UILabel *commentDeatilLabel;

@property (nonatomic, strong) TRZXProjectDetailCommentModel *model;

@end
