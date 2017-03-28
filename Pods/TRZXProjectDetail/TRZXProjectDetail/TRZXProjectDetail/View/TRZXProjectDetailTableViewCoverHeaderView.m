//
//  TRZXProjectDetailTableViewCoverHeaderView.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailTableViewCoverHeaderView.h"
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailModel.h"

@interface TRZXProjectDetailTableViewCoverHeaderView()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TRZXProjectDetailTableViewCoverHeaderView

- (void)addOwnViews
{
    [super addOwnViews];
    
    [self addSubview:self.headImageView];
    
    [self addSubview:self.titleLabel];
}

- (void)layoutFrameOfSubViews
{
    [super layoutFrameOfSubViews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.center.equalTo(self);
    }];
    
    _titleLabel.numberOfLines = 0;
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.centerX.equalTo(self);
        make.top.equalTo(_headImageView.mas_bottom).offset(20);
    }];
}

#pragma mark - <Setter/Getter>
- (void)setModel:(TRZXProjectDetailModel *)model
{
    _model = model;
    
    _titleLabel.text = self.title = model.data.name;
    
    self.coverImageUrl = model.data.topPic;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.data.logo] placeholderImage:[UIImage imageNamed:@"Icon_PlaceholderImage"]];
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.cornerRadius = 5;
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1.0);
    }
    return _titleLabel;
}
@end
