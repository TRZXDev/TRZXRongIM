//
//  RCDPublicPodfileHeaderCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/16.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicPodfileHeaderCell.h"
#import "RCDCommonDefine.h"

@interface RCDPublicPodfileHeaderCell ()

/**
  头像
 */
@property(nonatomic, strong) UIImageView *headImageView;

/**
 标题
 */
@property(nonatomic, strong) UILabel *titleLabel;

@end


@implementation RCDPublicPodfileHeaderCell

-(void)setProfile:(RCPublicServiceProfile *)profile{
    _profile = profile;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:profile.portraitUrl]];
    self.titleLabel.text = profile.name;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor trzx_BackGroundColor];
    }
    return self;
}

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.backgroundColor = self.contentView.backgroundColor = [UIColor trzx_BackGroundColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor trzx_BackGroundColor];
        _headImageView.RC_cornerRadius = 6;
//        _headImageView.kipo_borderWidth = 1;
//        _headImageView.kipo_borderColor = [UIColor trzx_LineColor];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(65, 65));
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-15);
        }];
    }
    return _headImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel RC_labelWithTitle:nil color:[UIColor trzx_TitleColor] fontSize:16];
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-15);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _titleLabel;
}

@end
