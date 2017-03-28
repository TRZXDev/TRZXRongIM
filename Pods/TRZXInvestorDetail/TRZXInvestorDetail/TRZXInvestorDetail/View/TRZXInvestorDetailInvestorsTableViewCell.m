//
//  TRZXInvestorDetailInvestorsTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailInvestorsTableViewCell.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailModel.h"

@interface TRZXInvestorDetailInvestorsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *investorInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

@implementation TRZXInvestorDetailInvestorsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.clipsToBounds = YES;
    _headImageView.layer.cornerRadius = 5;
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.top.equalTo(_headImageView);
        make.height.mas_equalTo(20);
    }];
    
    [_positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(_nameLabel);
    }];
    
    [_investorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_investorInfoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0.8);
        make.bottom.equalTo(self.contentView);
    }];
}


- (void)setOrgUserAuthList:(OrgUserAuthList *)orgUserAuthList
{
    _orgUserAuthList = orgUserAuthList;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:orgUserAuthList.photo] placeholderImage:[UIImage imageNamed:@"Icon_PlaceholderImage"]];
    self.nameLabel.text = orgUserAuthList.realName;
    self.positionLabel.text = orgUserAuthList.position;
    
    NSMutableAttributedString *attributedString = [[ NSMutableAttributedString alloc ] initWithString :orgUserAuthList.abstractz];
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    paragraphStyle. alignment = NSTextAlignmentLeft ;
    paragraphStyle. lineSpacing = 5 ;  //行自定义行高度
    [paragraphStyle setFirstLineHeadIndent : 30]; //首行缩进 根据用户昵称宽度在加5个像素
    [attributedString addAttribute : NSParagraphStyleAttributeName value :paragraphStyle range : NSMakeRange ( 0 , orgUserAuthList.abstractz.length)];
    
    self.investorInfoLabel.attributedText = attributedString;
}

@end
