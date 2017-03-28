//
//  IntroductionTableViewCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/1/28.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroductionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mobanBtn;
@property (weak, nonatomic) IBOutlet UILabel *jianjieLabel;
@property (weak, nonatomic) IBOutlet UITextView *IntroductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *zishuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuishaoLabel;

@end
