//
//  PikerTimeCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/23.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "PikerTimeCell.h"

@implementation PikerTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addTime:(id)sender {
}

- (IBAction)addDD:(id)sender {
    
    [self.delegate addDD];
}
@end
