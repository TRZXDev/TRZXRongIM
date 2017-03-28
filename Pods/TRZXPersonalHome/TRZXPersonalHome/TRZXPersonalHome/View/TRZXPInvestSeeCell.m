//
//  InvestSeeCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 16/3/9.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "TRZXPInvestSeeCell.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXPInvestSeeCell()
//@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TRZXPInvestSeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = backColor;
//    self.headImageView.layer.borderWidth = 0.5;
//    self.headImageView.layer.borderColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1].CGColor;
//    self.headImageView.layer.cornerRadius = 24;
    self.headImageView.layer.cornerRadius = 6;
    self.headImageView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.masksToBounds = YES;
    
}



@end
