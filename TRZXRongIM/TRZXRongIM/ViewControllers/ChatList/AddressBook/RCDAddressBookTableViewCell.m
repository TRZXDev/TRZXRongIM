//
//  RCDAddressBookTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/3/13.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDAddressBookTableViewCell.h"
#import "RCDUserInfo.h"
#import "RCDCommonDefine.h"

@implementation RCDAddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _imgvAva.layer.masksToBounds = YES;
    _imgvAva.RC_cornerRadius= 6;
    
}

-(void)setUser:(RCDUserInfo *)user{
    _user = user;
    self.lblName.text = user.name;
    [self.imgvAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
    self.mid = user.userId;
}

-(UILabel *)badgeNumberLabel{
    if (!_badgeNumberLabel) {
        _badgeNumberLabel = [UILabel RC_labelWithTitle:nil color:[UIColor whiteColor] fontSize:12];
        [self addSubview:_badgeNumberLabel];
        _badgeNumberLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        _badgeNumberLabel.RC_cornerRadius = 9;
        [_badgeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-20);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    return _badgeNumberLabel;
}


@end
