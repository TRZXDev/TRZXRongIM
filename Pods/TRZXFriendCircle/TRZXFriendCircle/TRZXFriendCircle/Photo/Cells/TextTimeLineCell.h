//
//  TextTimeLineCell.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXPhotoTextModel.h"
@interface TextTimeLineCell : UITableViewCell

@property (nonatomic,strong) TRZXPhotoTextModel* model;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeLineImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
