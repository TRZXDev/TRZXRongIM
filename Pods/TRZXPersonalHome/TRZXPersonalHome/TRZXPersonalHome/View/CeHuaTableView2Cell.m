//
//  CeHuaTableView2Cell.m
//  TRZX
//
//  Created by 张江威 on 16/6/13.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "CeHuaTableView2Cell.h"
#import "masonry.h"
@implementation CeHuaTableView2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hongdianImage = [[UIImageView alloc]init];
    self.hongdianImage.image = [UIImage imageNamed:@"guide_NEW"];
    [self addSubview:self.hongdianImage];
    [self.hongdianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tiaozhuanBtn);
        make.right.equalTo(self.tiaozhuanBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    self.hongdianImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
