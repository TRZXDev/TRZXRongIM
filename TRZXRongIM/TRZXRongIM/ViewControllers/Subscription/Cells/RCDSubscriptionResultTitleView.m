//
//  RCDSubscriptionResultTitleView.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSubscriptionResultTitleView.h"
#import "RCDCommonDefine.h"
@interface RCDSubscriptionResultTitleView ()

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation RCDSubscriptionResultTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self titleLabel];
        [self separatorView];
    }
    return self;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel RC_labelWithTitle:@"订阅刊" color:[UIColor trzx_TextColor] fontSize:17];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _titleLabel;
}

-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
        [self addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.offset(1);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _separatorView;
}

@end
