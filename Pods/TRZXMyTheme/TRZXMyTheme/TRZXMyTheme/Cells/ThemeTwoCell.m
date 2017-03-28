//
//  ThemeTwoCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ThemeTwoCell.h"


@implementation ThemeTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yuanchengView.hidden = YES;
    self.jinqianView.layer.cornerRadius = 12;
    self.jinqianView.layer.borderWidth = 1;
    self.jinqianView.layer.masksToBounds = YES;
    self.jinqianView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.yuanchengView.layer.cornerRadius = 12;
    self.yuanchengView.layer.borderWidth = 1;
    self.yuanchengView.layer.masksToBounds = YES;
    self.yuanchengView.layer.borderColor = [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1] CGColor];

//    self.dianjiView.layer.cornerRadius = 10;
//    self.dianjiView.layer.borderWidth = 0.8;
//    self.dianjiView.layer.masksToBounds = YES;
//    self.dianjiView.layer.borderColor = [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1] CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
