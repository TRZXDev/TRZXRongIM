//
//  RCDPublicProfileFooterView.m
//  TRZX
//
//  Created by 移动微 on 16/11/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicProfileFooterView.h"
#import "RCDCommonDefine.h"

@implementation RCDPublicProfileFooterView

-(void)footerButtonDidClick:(UIButton *)button{
    
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
    if (self.footerButtonBlock) {
        self.footerButtonBlock();
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor trzx_BackGroundColor];
        [self footerButton];
    }
    return self;
}

-(UIButton *)footerButton{
    if (!_footerButton) {
        _footerButton = [UIButton RC_buttonWithTitle:@"进入订阅刊" color:[UIColor whiteColor] imageName:nil target:self action:@selector(footerButtonDidClick:)];
        _footerButton.backgroundColor = [UIColor trzx_YellowColor];
        _footerButton.RC_cornerRadius = 6;
        [self addSubview:_footerButton];
        [_footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.offset(40);
        }];
    }
    return _footerButton;
}

@end
