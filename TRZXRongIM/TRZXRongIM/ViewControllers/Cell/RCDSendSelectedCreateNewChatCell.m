//
//  RCDSendSelectedCreateNewChatCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/19.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDSendSelectedCreateNewChatCell.h"
#import "RCDCommonDefine.h"

@interface RCDSendSelectedCreateNewChatCell ()

@end

@implementation RCDSendSelectedCreateNewChatCell

-(UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [UILabel RC_labelWithTitle:@"创建新聊天" color:[UIColor trzx_TitleColor] fontSize:15 aligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _promptLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self promptLabel];
    }
    return self;
}

@end
