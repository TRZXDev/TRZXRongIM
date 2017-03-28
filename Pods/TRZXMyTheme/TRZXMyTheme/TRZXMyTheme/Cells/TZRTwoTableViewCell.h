//
//  TZRTwoTableViewCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/3/3.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TZRTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhanshiLabel;
@property (weak, nonatomic) IBOutlet UIButton *tiaozhuanBtn;
@property (weak, nonatomic) IBOutlet UIImageView *yanzhanImage;
@property (weak, nonatomic) IBOutlet UILabel *xingLabel;

@end
