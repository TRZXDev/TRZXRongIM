//
//  SDTimeLineTableHeaderView.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//



#import "SDTimeLineTableHeaderView.h"

#import "UIView+SDAutoLayout.h"

#import "UIImageView+WebCache.h"

@implementation SDTimeLineTableHeaderView

{

    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


-(void)setPhotoTopDic:(NSDictionary *)photoTopDic{

    if(_photoTopDic!=photoTopDic){
        _nameLabel.text =  photoTopDic[@"userName"];
        [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:photoTopDic[@"topPic"]] placeholderImage:[UIImage imageNamed:@"TRZXBG"]];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds  = YES;


        [_iconView sd_setImageWithURL:[NSURL URLWithString:photoTopDic[@"usePic"]] placeholderImage:[UIImage imageNamed:@"展位图.png"]];


    }


}


- (void)setup
{
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.image = [UIImage imageNamed:@"展位图"];
    _backgroundImageView.userInteractionEnabled = YES;

    [self addSubview:_backgroundImageView];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"展位图"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 2;
    _iconView.layer.cornerRadius = 0;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;

    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:_nameLabel];
    
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-60, 0, 40, 0));
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 20);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
}


@end
