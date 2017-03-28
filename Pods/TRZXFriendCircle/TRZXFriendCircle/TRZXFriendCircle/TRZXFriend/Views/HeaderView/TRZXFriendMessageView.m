//
//  TRZXFriendMessageView.m
//  TRZX
//
//  Created by 张江威 on 2016/11/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXFriendMessageView.h"
#import "UIView+SDAutoLayout.h"

#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@implementation TRZXFriendMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
//    UIView * Vieww = [UIView new];
//    Vieww.backgroundColor = [UIColor whiteColor];
//    [self addSubview:Vieww];
//    Vieww.sd_layout
//    .heightIs(50)
//    .widthIs(self.frame.size.width)
//    .topSpaceToView(Vieww, 0)
//    .leftSpaceToView(Vieww, 0);
    self.backgroundColor = [UIColor whiteColor];
    _bgview = [UIView new];
    _bgview.backgroundColor = SDColor(69, 74, 76, 1);
    _bgview.layer.masksToBounds = YES;
    _bgview.tag = 20161108;
    _bgview.layer.cornerRadius = 4.0;
    [self addSubview:_bgview];
    
    _bjIconImage = [UIImageView new];
    _bjIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _bjIconImage.layer.masksToBounds = YES;
    _bjIconImage.layer.cornerRadius = 4.0;
    //    _bjIconImage.layer.borderWidth = 0;
    [_bgview addSubview:_bjIconImage];
//    [bjIconImage sd_setImageWithURL:[NSURL URLWithString:_messagImgStr] placeholderImage:[UIImage imageNamed:@"首页头像"]];
    UIImageView * zsImageView = [UIImageView new];
    [zsImageView setImage:[UIImage imageNamed:@"延展"]];
    [_bgview addSubview:zsImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    titleLabel.text = _messagTitStr;
    [_bgview addSubview:_titleLabel];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = backColor;
    [self addSubview:lineLabel];
    
    _bgview.sd_layout
    .heightIs(40)
    .widthIs(180)
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 10);
    
    _bjIconImage.sd_layout
    .heightIs(30)
    .widthIs(30)
    .leftSpaceToView(_bgview, 5)
    .centerYEqualToView(_bgview);
    
    zsImageView.sd_layout
    .widthIs(8)
    .heightIs(13)
    .rightSpaceToView(_bgview, 10)
    .centerYEqualToView(_bgview);
    
    _titleLabel.sd_layout
    .heightIs(40)
    .leftSpaceToView(_bjIconImage, 0)
    .rightSpaceToView(zsImageView, 0)
    .centerYEqualToView(_bgview);
    
    lineLabel.sd_layout
    .heightIs(1)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(_bgview, 9);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
