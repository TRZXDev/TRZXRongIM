//
//  PaymentCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *PurseView;
@property (weak, nonatomic) IBOutlet UIButton *Purse;
@property (weak, nonatomic) IBOutlet UIView *WeiXinView;
@property (weak, nonatomic) IBOutlet UIButton *WeiXin;
@property (weak, nonatomic) IBOutlet UIView *UnionPayView;
@property (weak, nonatomic) IBOutlet UIButton *UnionPay;
@property (weak, nonatomic) IBOutlet UILabel *BalanceLabel;

@end
