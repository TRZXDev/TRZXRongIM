//
//  TimeSiztView.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "TimeSiztView.h"

@implementation TimeSiztView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textttView.editable = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Sizt_CancleClick:(id)sender {
    
    self.hidden = YES;
}
@end
