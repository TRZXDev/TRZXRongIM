//
//  TRZXProjectCell.m
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectCell.h"
#import "UIImageView+AFNetworking.h"
#import "TRZXKit.h"

@implementation TRZXProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _projectCoversImageView.layer.cornerRadius =   5;
    _projectCoversImageView.layer.masksToBounds = YES;

    _bgView.layer.cornerRadius =   5;
    _bgView.layer.masksToBounds = YES;

    _nameLabel.textColor = [UIColor trzx_NavTitleColor];

}

- (void)setProject:(TRZXProject *)project{
    if (_project!=project) {
        _project = project;

        [_projectCoversImageView setImageWithURL:[NSURL URLWithString:project.logo]];
        _nameLabel.text = project.name;
        _tradeInfoLabel.text = [NSString stringWithFormat:@"%@/%@",project.tradeInfo,project.areaName] ;
        _contentLabel.text = [NSString stringWithFormat:@"%@",project.briefIntroduction];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
