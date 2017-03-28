//
//  TRZXInvestorBaseInfoTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/13.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorBaseInfoTableViewCell.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailModel.h"

@interface TRZXInvestorBaseInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *lfetredLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TRZXInvestorBaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_lfetredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(2);
        make.top.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lfetredLabel.mas_right).offset(5);
        make.top.bottom.equalTo(_lfetredLabel);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lfetredLabel.mas_bottom).offset(12);
        make.left.equalTo(_lfetredLabel).offset(2);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_topLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
}


- (void)setInvestorData:(InvestorData *)data indexPath:(NSIndexPath *)indexPath isInvestor:(NSNumber *)isInvestor
{
    NSString *titleString = nil;
    NSString *detailString = nil;
    
    BOOL isInvestorI = [isInvestor boolValue];
    
    switch (indexPath.row) {
        case 0:
        {
            titleString = @"投资领域";
            detailString = [self handleOrigin:data];
        }
            
            break;
        case 1:
        {
            titleString = isInvestorI ? @"计划投资" : @"基金规模";
            detailString = isInvestorI ? [NSString stringWithFormat:@"%@个/年",data.planInvest] : [NSString stringWithFormat:@"%@亿人民币",data.foundSize];
        }
            
            break;
        case 2:
        {
            titleString = @"机构所在地";
            detailString = isInvestorI ? data.city : data.cityName;
        }
            
            break;
            
        default:
            break;
    }
    
    _titleLabel.text = titleString;
    _detailLabel.text = detailString;
    
    _topLineView.hidden = indexPath.row != 0;
    
    [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(indexPath.row == 2 ? -10 : 0);
    }];
    
    [_lfetredLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(indexPath.row == 0 ? 20 : 10);
    }];
}

-(NSString *)handleOrigin:(InvestorData *)orginfoModel{
    
    __block NSMutableString *str;
    
    [orginfoModel.focusTrades enumerateObjectsUsingBlock:^(FocusTrades * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        FocusTrades *focusTrade = obj;
        
        str = [NSMutableString stringWithFormat:@"%@/%@",str?str:@"",focusTrade.trade];
    }];
    
    [str stringByReplacingOccurrencesOfString:@"、" withString:@"/"];
    [str stringByReplacingOccurrencesOfString:@"和" withString:@"/"];
    
    return [str substringFromIndex:1];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
