//
//  RCDCollectionChatListCell.m
//  TRZX
//
//  Created by 移动微 on 16/12/2.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDCollectionChatListCell.h"
#import "RCDCommonDefine.h"
#import <Masonry/Masonry.h>
#import "UIView+RCExtension.h"
#import "UILabel+RCExtension.h"
#import <TRZXKit/UIColor+APP.h>

@interface RCDCollectionChatListCell ()

/**
 未读消息
 */
@property(nonatomic, strong) UILabel *unreadLabel;

@property(nonatomic, strong) UIView *separatorView;

@end

@implementation RCDCollectionChatListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self contentLabel];
        [self headImageView];
        [self titleLabel];
        [self timeLabel];
        [self separatorView];
    }
    return self;
}

-(void)setUnreadCount:(int)count{
    
    if (count > 0) {
        self.unreadLabel.hidden = NO;
        NSString *countStr = [NSString stringWithFormat:@"%d",count];
        self.unreadLabel.text = countStr;
        if (count > 9) {
            [self.unreadLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset([self sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(50, 18) string:countStr].width + 5);
            }];
        }
    }else{
        self.unreadLabel.hidden = YES;
    }
}
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize string:(NSString *)string
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark - properties
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.RC_cornerRadius = 6;
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
    }
    return _headImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TitleColor] fontSize:17 aligment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView).offset(5);
            make.left.equalTo(self.headImageView.mas_right).offset(10);
        }];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] fontSize:14 aligment:NSTextAlignmentLeft];
        _contentLabel.numberOfLines = 1;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return _contentLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] fontSize:14];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return _timeLabel;
}

-(UILabel *)unreadLabel{
    if (!_unreadLabel) {
        _unreadLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor whiteColor] fontSize:12];
        _unreadLabel.RC_cornerRadius = 9;
        _unreadLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_unreadLabel];
        [_unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headImageView.mas_right).offset(7);
            make.centerY.equalTo(self.headImageView.mas_top);
//            make.size.mas_equalTo(CGSizeMake(18, 18));
            make.height.offset(18);
            make.width.offset(18);
        }];
    }
    return _unreadLabel;
}

-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView RC_viewWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]];
        [self.contentView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView);
            make.height.offset(1);
        }];
    }
    return _separatorView;
}

@end
