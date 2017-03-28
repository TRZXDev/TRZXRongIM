//
//  WriteDataCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/23.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "WriteDataCell.h"

@implementation WriteDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)queRenBtn:(id)sender {
    [self.delegate pushBtnType:@"确认"];
}

- (IBAction)quXiaoBtn:(id)sender {
//    [self.delegate pushBtnType:@"取消"];
    self.hidden = YES;
}
@end
