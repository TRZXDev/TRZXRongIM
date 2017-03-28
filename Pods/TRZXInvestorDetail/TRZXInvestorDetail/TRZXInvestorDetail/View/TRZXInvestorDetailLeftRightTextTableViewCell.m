//
//  TRZXInvestorDetailLeftRightTextTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/13.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailLeftRightTextTableViewCell.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailModel.h"

@interface TRZXInvestorDetailLeftRightTextTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *leftRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TRZXInvestorDetailLeftRightTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_leftRedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    
    [_detailLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _detailLabel.textAlignment             = NSTextAlignmentLeft;
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(23);
    }];
}


- (void)setInvestmentStage:(InvestmentStages *)InvestmentStage
{
    _InvestmentStage = InvestmentStage;
    
    _leftRedLabel.text = InvestmentStage.name;
    
    _detailLabel.text = [NSString stringWithFormat:@"¥%@万-%@万",InvestmentStage.minInvestmentAmount,InvestmentStage.maxInvestmentAmount];
}
@end
