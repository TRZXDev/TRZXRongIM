//
//  TRZXProjectDetailAuthorTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailAuthorTableViewCell.h"
#import "TRZXProjectDetailDataModel.h"

@interface TRZXProjectDetailAuthorTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorAbsLabel;

@end

@implementation TRZXProjectDetailAuthorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(TRZXProjectDetailDataModel *)model
{
    _model = model;
    
    _authorNameLabel.text = model.authorName;
    
//    _authorAbsLabel.text = [NSString stringWithFormat:@"    %@", model.authorAbs];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_model.authorAbs];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:3];
    [paragraph setFirstLineHeadIndent:30];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attribute.length)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1]} range:NSMakeRange(0, attribute.length)];
    _authorAbsLabel.attributedText = attribute;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
