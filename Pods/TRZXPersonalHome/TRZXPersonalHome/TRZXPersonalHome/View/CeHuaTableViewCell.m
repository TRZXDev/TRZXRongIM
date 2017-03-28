//
//  CeHuaTableViewcell.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/20.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "CeHuaTableViewcell.h"
#import "masonry.h"

@implementation CeHuaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.hongdianImage = [[UIImageView alloc]init];
    self.hongdianImage.image = [UIImage imageNamed:@"guide_NEW"];
    [self addSubview:self.hongdianImage];
    [self.hongdianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gonglueBtn);
        make.right.equalTo(self.gonglueBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];

    self.hongdianImage.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
