//
//  RCDSearchResultTableViewCell.m
//  RCloudMessage
//
//  Created by Liv on 15/4/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDSearchResultTableViewCell.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"
#import "RCDCommonDefine.h"

@implementation RCDSearchResultTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ivAva = [UIImageView new];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 8.f;
        _lblName = [UILabel new];
        _officialImage = [[UIImageView alloc]initWithImage:[UIImage RC_BundleImgName:@"RCDOfficial"]];
        [self addSubview:_ivAva];
        [self addSubview:_lblName];
        [self addSubview:_officialImage];
        
        [_ivAva setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lblName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_officialImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_ivAva(56)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_ivAva)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_ivAva attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lblName(20)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_lblName)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_lblName attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_ivAva(56)]-8-[_lblName]-16-|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_ivAva,_lblName)]];
        [_officialImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_ivAva.mas_right);
            make.centerY.equalTo(_ivAva.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        _officialImage.hidden = YES;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)setUser:(RCDUserInfo *)user{
    _user = user;
    self.lblName.text = user.name;
    if(user.portraitUri.length){
        [self.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }else if([[RCDataBaseManager shareInstance] getUserByUserId:user.userId].portraitUri){
        [self.ivAva sd_setImageWithURL:[NSURL URLWithString:[[RCDataBaseManager shareInstance] getUserByUserId:user.userId].portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
}

@end
