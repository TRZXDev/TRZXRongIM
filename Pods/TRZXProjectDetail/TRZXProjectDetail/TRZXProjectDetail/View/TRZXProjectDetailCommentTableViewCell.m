//
//  TRZXProjectDetailCommentTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/4.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailCommentTableViewCell.h"
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailCommentOfOneView.h"
#import "TRZXProjectDetailModel.h"

@interface TRZXProjectDetailCommentTableViewCell()

@property (nonatomic, strong) UIView *leftRedView;

@property (nonatomic, strong) UILabel *commentTitleLabel;

@property (nonatomic, strong) UILabel *commentCountLabel;

@property (nonatomic, strong) UIView *separateLineView;

@property (nonatomic, strong) UITextField *commentTextField;

@property (nonatomic, strong) UILabel *moreCommentLable;

@property (nonatomic, strong) TRZXProjectDetailCommentOfOneView *commentOfOneView;

@property (nonatomic, strong) UIView *moreSparateLineView;

@end

@implementation TRZXProjectDetailCommentTableViewCell

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
    [self.contentView addSubview:self.leftRedView];
    [self.contentView addSubview:self.commentTitleLabel];
    [self.contentView addSubview:self.commentCountLabel];
    [self.contentView addSubview:self.separateLineView];
    [self.contentView addSubview:self.commentTextField];
    [self.contentView addSubview:self.commentOfOneView];
    [self.contentView addSubview:self.moreSparateLineView];
    [self.contentView addSubview:self.moreCommentLable];
}

- (void)layoutFrameOfSubViews
{
    [_leftRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(2, 25));
    }];
    
    [_commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftRedView.mas_right).offset(10);
        make.top.bottom.equalTo(_leftRedView);
        make.width.mas_equalTo(30);
    }];
    
    [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentTitleLabel.mas_right).offset(10);
        make.top.bottom.equalTo(_commentTitleLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_commentCountLabel);
        make.top.equalTo(_commentCountLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(0.5);
    }];
    
    [_commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_separateLineView);
        make.top.equalTo(_separateLineView.mas_bottom).offset(8);
        make.height.mas_equalTo(30);
    }];
    
    [_commentOfOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_commentTextField.mas_bottom);
    }];
    
    [_moreSparateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(_commentOfOneView.mas_bottom);
    }];
    
    [_moreCommentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(_moreSparateLineView.mas_bottom);
    }];
}



- (void)setModel:(TRZXProjectDetailModel *)model
{
    _model = model;
    
    _commentCountLabel.text = [NSString stringWithFormat:@"%ld条评价", model.commentsJson.count];
    
    if (model.commentsJson.count > 0) {
        
        _commentOfOneView.hidden = NO;
        
        _commentOfOneView.model = model.commentsJson.firstObject;
        
        [self layoutIfNeeded];
        [_commentOfOneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(CGRectGetMaxY(_commentOfOneView.commentDeatilLabel.frame)+5);
        }];
        
    }else {
        
        _commentOfOneView.hidden = YES;
        
        [_commentOfOneView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
    }
    
    _moreCommentLable.hidden = _moreSparateLineView.hidden = model.commentsJson.count < 1;
    
    [_moreCommentLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.commentsJson.count > 1 ? 30 : 0);
    }];
    
}

#pragma mark - <Setter/Getter>
- (UIView *)leftRedView
{
    if (!_leftRedView) {
        _leftRedView = [[UIView alloc] init];
        _leftRedView.backgroundColor = [UIColor trzx_RedColor];
    }
    return _leftRedView;
}

- (UILabel *)commentTitleLabel
{
    if (!_commentTitleLabel) {
        _commentTitleLabel = [[UILabel alloc] init];
        _commentTitleLabel.text = @"评论";
        _commentTitleLabel.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1];
        _commentTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _commentTitleLabel;
}

- (UILabel *)commentCountLabel
{
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.textColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1];
        _commentCountLabel.font = [UIFont systemFontOfSize:12];
    }
    return _commentCountLabel;
}

- (UIView *)separateLineView
{
    if (!_separateLineView) {
        _separateLineView = [[UIView alloc] init];
        _separateLineView.backgroundColor = [UIColor trzx_LineColor];
    }
    return _separateLineView;
}

- (UITextField *)commentTextField
{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] init];
        _commentTextField.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        _commentTextField.placeholder = @"有什么感想快来说说吧";
        [_commentTextField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        _commentTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commentTextField.tintColor = [UIColor whiteColor];
    }
    return _commentTextField;
}

- (TRZXProjectDetailCommentOfOneView *)commentOfOneView
{
    if (!_commentOfOneView) {
        _commentOfOneView = [[TRZXProjectDetailCommentOfOneView alloc] init];
    }
    return _commentOfOneView;
}

- (UILabel *)moreCommentLable
{
    if (!_moreCommentLable) {
        _moreCommentLable = [[UILabel alloc] init];
        _moreCommentLable.text = @"点击查看更多>";
        _moreCommentLable.textAlignment = NSTextAlignmentRight;
        _moreCommentLable.font = [UIFont systemFontOfSize:12];
        _moreCommentLable.userInteractionEnabled = YES;
        _moreCommentLable.textColor = [UIColor trzx_RedColor];
        [_moreCommentLable addGestureRecognizer:self.moreLabelTapGesture];
    }
    return _moreCommentLable;
}

- (UITapGestureRecognizer *)moreLabelTapGesture
{
    if (!_moreLabelTapGesture) {
        _moreLabelTapGesture = [[UITapGestureRecognizer alloc] init];
    }
    return _moreLabelTapGesture;
}

- (UIView *)moreSparateLineView
{
    if (!_moreSparateLineView) {
        _moreSparateLineView = [[UIView alloc] init];
        _moreSparateLineView.backgroundColor = [UIColor trzx_LineColor];
    }
    return _moreSparateLineView;
}

@end
