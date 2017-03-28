//
//  TRZXProjectDetailTeamTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailTeamTableViewCell.h"
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailDataModel.h"

@interface TRZXProjectDetailTeamTableViewCell()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *positionLabel;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation TRZXProjectDetailTeamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self addOwnViews];
    [self layoutFrameOfSubViews];
    
    return self;
}
- (void)addOwnViews
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.positionLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.bottomLineView];
}

- (void)layoutFrameOfSubViews
{
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-20);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView);
        make.left.equalTo(_headImageView.mas_right).offset(10);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(12);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    _describeLabel.numberOfLines = 3;
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.left.right.equalTo(self.contentView);
    }];
}

- (void)setModel:(TRZXProjectDetailDataTeamModel *)model
{
    _model = model;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"Icon_PlaceholderImage"]];
    
    _nameLabel.text = model.name;
    
    _positionLabel.text = model.position;
    
    _describeLabel.text = model.abstractz;
}

#pragma mark - <Setter/Getter>
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 5;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor trzx_colorWithHexString:@"#484848"];
    }
    return _nameLabel;
}

- (UILabel *)positionLabel
{
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.font = [UIFont systemFontOfSize:12];
        _positionLabel.textColor = [UIColor trzx_colorWithHexString:@"#484848"];

    }
    return _positionLabel;
}

- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.textColor = [UIColor trzx_colorWithHexString:@"#AAAAAA"];

    }
    return _describeLabel;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor trzx_LineColor];
    }
    return _bottomLineView;
}

@end
