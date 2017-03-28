//
//  ChonghuayjnCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/1/7.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetModel.h"

@interface ChonghuayjnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UILabel *textLable;



@property (strong, nonatomic) MeetModel *model;
@end
