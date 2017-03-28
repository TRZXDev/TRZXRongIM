//
//  RCDSelectPersonTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/3/27.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSelectPersonTableViewCell.h"
#import "RCDCommonDefine.h"

@implementation RCDSelectPersonTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
//    self.ivAva.clipsToBounds = YES;
//    self.ivAva.layer.cornerRadius = 8.f;
    self.ivAva.RC_cornerRadius = 6;
    self.backgroundColor = self.contentView.backgroundColor = [UIColor trzx_BackGroundColor];
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        _ivSelected.image = [UIImage RC_BundleImgName:@"RCDSelectPerson_Select"];
    }else{
        _ivSelected.image = [UIImage RC_BundleImgName:@"unselect"];
    }
}

@end
