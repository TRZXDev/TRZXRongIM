//
//  TRZXProjectDeatilCommentOfOneTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/4.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailCommentOfOneView.h"
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailModel.h"

@implementation TRZXProjectDetailCommentOfOneView

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self addOwnViews];
    [self layoutFrameOfSubViews];
    
    return self;
}
- (void)addOwnViews
{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.sendCommentTimeLabel];
    [self addSubview:self.commentDeatilLabel];
}

- (void)layoutFrameOfSubViews
{
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(6);
        make.top.equalTo(_headImageView);
    }];
    
    [_sendCommentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.bottom.equalTo(_headImageView);
    }];
    
    _commentDeatilLabel.numberOfLines = 0;
    [_commentDeatilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView);
        make.top.equalTo(_headImageView.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
}

#pragma mark - <Setter/Getter>
- (void)setModel:(TRZXProjectDetailCommentModel *)model
{
    _model = model;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.commentUserPhoto] placeholderImage:[UIImage imageNamed:@"Icon_PlaceholderImage"] options:SDWebImageRefreshCached|SDWebImageCacheMemoryOnly];
    
    _nameLabel.text = model.commentUserName;
    
    _sendCommentTimeLabel.text = model.dateInfo;
    
    _commentDeatilLabel.text = model.remarks;
}

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
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1];
    }
    return _nameLabel;
}

- (UILabel *)sendCommentTimeLabel
{
    if (!_sendCommentTimeLabel) {
        _sendCommentTimeLabel = [[UILabel alloc] init];
        _sendCommentTimeLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
        _sendCommentTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _sendCommentTimeLabel;
}

- (UILabel *)commentDeatilLabel
{
    if (!_commentDeatilLabel) {
        _commentDeatilLabel = [[UILabel alloc] init];
        _commentDeatilLabel.font = [UIFont systemFontOfSize:16];
        _commentDeatilLabel.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1];
    }
    return _commentDeatilLabel;
}

@end
