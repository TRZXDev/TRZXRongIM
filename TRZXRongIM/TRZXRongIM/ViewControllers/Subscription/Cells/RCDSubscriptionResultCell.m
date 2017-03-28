//
//  RCDSubscriptionResultCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSubscriptionResultCell.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDCommonDefine.h"

@interface RCDSubscriptionResultCell ()
/**
 头像
 */
@property(nonatomic, strong) UIImageView *headImageView;

/**
 标题
 */
@property(nonatomic, strong) UILabel *titleLabel;

/**
 内容
 */
@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UIImageView *vipImage;

@end

@implementation RCDSubscriptionResultCell


-(void)setProfile:(RCPublicServiceProfile *)profile{
    _profile = profile;
    
    self.titleLabel.text = profile.name;
    self.contentLabel.text = profile.introduction;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
    
}


#pragma mark - Properties
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        _headImageView.RC_cornerRadius = 5;
        _headImageView.RC_borderWidth = 1;
        _headImageView.RC_borderColor = [UIColor trzx_LineColor];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(18);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
    }
    return _headImageView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TitleColor] fontSize:16 aligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self.headImageView.mas_right).offset(15);
            make.right.equalTo(self.vipImage.mas_left).offset(-10);
        }];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TextColor] fontSize:13 aligment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 2;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return _contentLabel;
}

-(UIImageView *)vipImage{
    if (!_vipImage) {
        _vipImage = [UIImageView RC_imageViewWithImageName:@"RCDSubscription_authenticate"];
        [self.contentView addSubview:_vipImage];
        [_vipImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return _vipImage;
}

@end
