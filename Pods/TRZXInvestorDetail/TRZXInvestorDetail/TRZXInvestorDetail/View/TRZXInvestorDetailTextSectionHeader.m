//
//  TRZXInvestorDetailTextSectionHeader.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/13.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailTextSectionHeader.h"

@interface TRZXInvestorDetailTextSectionHeader()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TRZXInvestorDetailTextSectionHeader

- (void)setTextString:(NSString *)textString
{
    _textString = textString;
    _titleLabel.text = textString;
}

@end
