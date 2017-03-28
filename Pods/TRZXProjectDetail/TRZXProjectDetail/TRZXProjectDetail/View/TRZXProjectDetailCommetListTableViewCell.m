//
//  TRZXProjectDetailCommetListTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailCommetListTableViewCell.h"
#import "TRZXProjectDetailCommentOfOneView.h"
#import "TRZXProjectDetailMacro.h"

@interface TRZXProjectDetailCommetListTableViewCell()

@property (strong, nonatomic) TRZXProjectDetailCommentOfOneView *commetView;

@end

@implementation TRZXProjectDetailCommetListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.commetView];
    
    [_commetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
}

- (void)setModel:(TRZXProjectDetailCommentModel *)model
{
    _model = model;
    
    _commetView.model = model;
    
    [self layoutIfNeeded];
    [_commetView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(_commetView.commentDeatilLabel.frame)+5);
    }];
}

#pragma mark - <Setter/Getter>
- (TRZXProjectDetailCommentOfOneView *)commetView
{
    if (!_commetView) {
        _commetView = [[TRZXProjectDetailCommentOfOneView alloc] init];
    }
    return _commetView;
}

@end
