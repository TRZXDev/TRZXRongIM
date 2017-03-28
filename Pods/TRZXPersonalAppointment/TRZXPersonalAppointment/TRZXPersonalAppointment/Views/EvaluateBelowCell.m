//
//  EvaluateBelowCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "EvaluateBelowCell.h"

@implementation EvaluateBelowCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ConsultBtn:(id)sender {
    
    [self.delegate TransmitType:@"ConsultBtn"];
}

- (IBAction)Myintroduce:(id)sender {
    [self.delegate TransmitType:@"Myintroduce"];
}

- (IBAction)TimeSite:(id)sender {
    [self.delegate TransmitType:@"TimeSite"];
}

- (IBAction)IphoneBtn:(id)sender {
    [self.delegate TransmitType:@"IphoneBtn"];
}
@end
