//
//  TRZXInvestorDetailOnlyTextTableViewCell.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/13.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailOnlyTextTableViewCell.h"

@interface TRZXInvestorDetailOnlyTextTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TRZXInvestorDetailOnlyTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDetailString:(NSString *)detailString
{
    _detailString = detailString;
    
    //                1.创建可变字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:detailString?detailString:@""];
    //                2.设置行间距
    NSMutableParagraphStyle *paragraphStyle =
    [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    //         设置首行缩进
    [paragraphStyle setFirstLineHeadIndent : 30];
    //                3.可变字符串添加行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailString.length)];
    
    _detailLabel.attributedText = attributedString;
    [_detailLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
