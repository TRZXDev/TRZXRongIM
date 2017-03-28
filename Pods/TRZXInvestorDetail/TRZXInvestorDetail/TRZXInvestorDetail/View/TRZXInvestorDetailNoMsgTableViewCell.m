//
//  TRZXInvestorDetailNoMsgTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/13.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailNoMsgTableViewCell.h"
#import "TRZXInvestorDetailMacro.h"

@interface TRZXInvestorDetailNoMsgTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *leftredLine;
@property (weak, nonatomic) IBOutlet UIView *rightredLine;
@property (weak, nonatomic) IBOutlet UILabel *investSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAbleOfoneLabel;

@end

@implementation TRZXInvestorDetailNoMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_leftredLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(0.52);
        make.width.mas_equalTo(2);
    }];
    
    [_investSectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftredLine.mas_right).offset(5);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [_rightredLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(0.52);
        make.width.mas_equalTo(2);
    }];
    
    [_investAbleOfoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightredLine.mas_right).offset(5);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(28);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
