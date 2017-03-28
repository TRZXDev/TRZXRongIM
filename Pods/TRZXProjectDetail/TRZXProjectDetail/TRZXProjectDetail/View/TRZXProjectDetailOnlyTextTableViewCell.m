//
//  TRZXProjectDetailOnlyTextTableViewCell.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailOnlyTextTableViewCell.h"
#import "TRZXProjectDetailMacro.h"

@interface TRZXProjectDetailOnlyTextTableViewCell()

@property (nonatomic, strong) UILabel *aDetailTextLabel;

@end

@implementation TRZXProjectDetailOnlyTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self.contentView addSubview:self.aDetailTextLabel];
    
    _aDetailTextLabel.numberOfLines = 0;
    [_aDetailTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_aDetailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    return self;
}

#pragma mark - <Setter/Getter>
- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:textString];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    [paragraph setLineSpacing:3];
    [paragraph setFirstLineHeadIndent:30];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attribute.length)];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1]} range:NSMakeRange(0, attribute.length)];
    _aDetailTextLabel.attributedText = attribute;
}
- (UILabel *)aDetailTextLabel
{
    if (!_aDetailTextLabel) {
        _aDetailTextLabel = [[UILabel alloc] init];
        _aDetailTextLabel.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
        _aDetailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _aDetailTextLabel;
}

@end
