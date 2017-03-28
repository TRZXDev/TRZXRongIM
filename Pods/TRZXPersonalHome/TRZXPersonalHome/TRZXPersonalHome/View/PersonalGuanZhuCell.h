//
//  PersonalGuanZhuCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/12.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXCareAboutModel.h"
@interface PersonalGuanZhuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icmImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongsiLabel;

@property (strong, nonatomic) Data * model;

@end
