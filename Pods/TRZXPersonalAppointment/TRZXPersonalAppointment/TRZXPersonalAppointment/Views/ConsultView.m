//
//  ConsultView.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ConsultView.h"

@implementation ConsultView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.texttView.editable = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)CanCleBtnClick:(id)sender {
    
    self.hidden =YES;
}
@end
