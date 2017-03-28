//
//  ChoosetimeCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ChoosetimeCell.h"

@implementation ChoosetimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)CloseBtn:(id)sender {
    [self.delegate deleteNymber:self.NumberLable.text];
//    self.hidden = YES;
}
@end
