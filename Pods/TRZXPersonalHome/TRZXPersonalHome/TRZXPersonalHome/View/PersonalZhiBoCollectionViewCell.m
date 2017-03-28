//
//  PersonalZhiBoCollectionViewCell.m
//  tourongzhuanjia
//
//  Created by Rhino on 16/6/7.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalZhiBoCollectionViewCell.h"

@implementation PersonalZhiBoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}

@end
