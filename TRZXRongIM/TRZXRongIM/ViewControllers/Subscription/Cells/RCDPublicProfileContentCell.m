//
//  RCDPublicProfileContentCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/16.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicProfileContentCell.h"
#import "RCDCommonDefine.h"
#import "UILabel+RCExtension.h"
#import "Masonry.h"
#import "UIView+RCExtension.h"
#import <TRZXKit/UIColor+APP.h>

@interface RCDPublicProfileContentCell ()

/**
 标题
 */
@property(nonatomic, strong) UILabel *titleLabel;

/**
 内容
 */
@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UIView *backView;

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation RCDPublicProfileContentCell

-(void)setProfile:(RCPublicServiceProfile *)profile{
    _profile = profile;
    
    [self setData];
}

#pragma mark - Private
-(void)setData{
    switch (self.type) {
        case ProfileContentCellTypeIntroduction:{
            self.titleLabel.text = @"功能介绍";
            self.contentLabel.text = self.profile.introduction;
            self.contentLabel.textAlignment = NSTextAlignmentLeft;
        }break;
        case ProfileContentCellTypeBody:{
            self.titleLabel.text = @"公司刊号";
            self.contentLabel.text = self.profile.publicServiceId;
            self.contentLabel.textAlignment = NSTextAlignmentRight;
        }break;
        case ProfileContentCellTypeMobile:{
            self.titleLabel.text = @"客服电话";
        }break;
        default:
            break;
    }
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.contentMode = UIViewContentModeScaleAspectFill;
        [self separatorView];
    }
    return self;
}

#pragma mark - Properties
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel RC_labelWithTitle:nil color:[UIColor trzx_NavTitleColor] fontSize:15];
        [self.backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).offset(15);
            make.top.equalTo(self.backView).offset(10);
        }];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TextColor] fontSize:14 aligment:NSTextAlignmentLeft];
        _contentLabel.clipsToBounds = YES;
        [self.backView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-23);
            make.left.equalTo(self.contentView).offset(120);
        }];
        
    }
    return _contentLabel;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        [self.contentView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentLabel).offset(10);
        }];
    }
    return _backView;
}

-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView RC_viewWithColor:[UIColor whiteColor]];
        [self.contentView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView.mas_bottom);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.offset(1);
        }];
    }
    return _separatorView;
}

@end
