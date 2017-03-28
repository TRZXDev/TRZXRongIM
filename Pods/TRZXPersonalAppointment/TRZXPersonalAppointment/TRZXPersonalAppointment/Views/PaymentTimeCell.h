//
//  PaymentTimeCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *HourLable;
@property (weak, nonatomic) IBOutlet UILabel *MinuteLable;
@property (weak, nonatomic) IBOutlet UIView *HintView;
@property (weak, nonatomic) IBOutlet UILabel *NonsenseLable;

@end
