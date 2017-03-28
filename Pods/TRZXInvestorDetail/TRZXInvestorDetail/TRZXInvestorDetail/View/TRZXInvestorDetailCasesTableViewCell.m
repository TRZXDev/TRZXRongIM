//
//  TRZXInvestorDetailCasesTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailCasesTableViewCell.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailModel.h"

@interface TRZXInvestorDetailCasesTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;
@property (weak, nonatomic) IBOutlet UIView *dotLineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic) IBOutlet UIView *tradeLineView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *rightredView;


@end

@implementation TRZXInvestorDetailCasesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel);
    }];
    
    [_dotLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.8);
        make.top.equalTo(_dotImageView.mas_bottom);
        make.centerX.equalTo(_dotImageView);
        make.height.mas_equalTo(42);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dotImageView.mas_right).offset(10);
        make.centerY.equalTo(_dotImageView);
    }];
    
    
    _backGroundView.layer.cornerRadius = 6;
    _backGroundView.layer.borderWidth = 1;
    _backGroundView.layer.borderColor = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:244/255.0 alpha:1].CGColor;
    [_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(7);
        make.bottom.equalTo(_dotLineView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [_tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_backGroundView);
        make.width.equalTo(_backGroundView).multipliedBy(0.3);
        make.left.equalTo(_backGroundView);
    }];
    
    [_tradeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tradeLabel.mas_right);
        make.height.equalTo(_backGroundView).multipliedBy(0.8);
        make.centerY.equalTo(_backGroundView);
        make.width.mas_equalTo(0.8);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tradeLineView.mas_right).offset(10);
        make.top.bottom.equalTo(_backGroundView);
        make.right.equalTo(_rightredView.mas_left);
    }];
    
    [_rightredView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(_backGroundView);
        make.width.mas_equalTo(8);
    }];
    
}

- (void)setInvestmentCase:(InvestmentCases *)investmentCase
{
    _investmentCase = investmentCase;
    
    _contentLabel.text = [NSString stringWithFormat:@"总投资额 ￥%@万", investmentCase.amount];
    _titleLabel.text = investmentCase.name;
    _timeLabel.text = [investmentCase.investmentTime substringWithRange:NSMakeRange(0, 10)];
    _tradeLabel.text = investmentCase.areaName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
