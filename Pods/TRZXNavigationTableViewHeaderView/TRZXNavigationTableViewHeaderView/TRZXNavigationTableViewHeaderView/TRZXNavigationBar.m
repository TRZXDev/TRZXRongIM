//
//  TRZXProjectDetailNavigationView.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXNavigationBar.h"
#import <Masonry/Masonry.h>

@interface TRZXNavigationBar()

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 返回按钮
 */
@property (nonatomic, strong) UIButton *backButton;

/**
 收藏按钮
 */
@property (nonatomic, strong) UIButton *collectButton;

/**
 分享按钮
 */
@property (nonatomic, strong) UIButton *shareButton;

/**
 底部线
 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation TRZXNavigationBar


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        [self addOwnViews];
        
        [self layoutFrmeOfSubViews];
        
    }
    return self;
}

- (void)addOwnViews
{
    [self addSubview:self.backButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.collectButton];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.titleLabel];
}

- (void)layoutFrmeOfSubViews
{
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.width.mas_equalTo(83);
        make.left.bottom.equalTo(_bottomLineView);
    }];
    
    [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(35);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [_collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shareButton.mas_left).offset(-12);
        make.centerY.equalTo(_shareButton);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.4);
        make.height.mas_equalTo(44);
    }];
}

- (void)composeButtonClicked:(UIButton *)sender
{
    if (sender.tag == ENavigationBarAction_Collect) {
        sender.selected = !sender.isSelected;
    }
    if (self.onNavigationBarActionBlock) {
        self.onNavigationBarActionBlock(sender.tag, sender);
    }
}

#pragma mark - <Public-Method>
- (void)makeNavigationBarIsShowWithContentOfsetY:(CGFloat)y
{
    CGFloat headerHeight = ([[UIScreen mainScreen] bounds].size.width) * 3 / 4;
    
    BOOL isShow = y > (headerHeight - 64);
    
    CGFloat minOffset = headerHeight - 64;
    
    CGFloat progress = (y / minOffset);
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:progress];
    
    _titleLabel.hidden = !isShow;
    
    _bottomLineView.hidden = !isShow;
    
    
    [_backButton setTitleColor:isShow ? [UIColor grayColor] : [UIColor whiteColor] forState:UIControlStateNormal];

    UIImage *backNormalImage = [UIImage imageNamed:isShow ? @"Icon_NavigationBar_Back_Normal_Gray" : @"Icon_NavigationBar_Back_Normal_White"];
    [_backButton setImage:backNormalImage forState:UIControlStateNormal];
    
    UIImage *collectionNormalImage = [UIImage imageNamed:isShow ? @"Icon_NavigationBar_Collection_Normal_Gray" : @"Icon_NavigationBar_Collection_Normal_White"];
    [_collectButton setImage:collectionNormalImage forState:UIControlStateNormal];
    
    UIImage *shareNormalImage = [UIImage imageNamed:isShow ? @"Icon_NavigationBar_Share_Normal_Gray" : @"Icon_NavigationBar_Share_Normal_White"];
    [_shareButton setImage:shareNormalImage forState:UIControlStateNormal];
}

#pragma mark - <Setter/Getter>
- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:90 /255.0 green:90 /255.0 blue:90 /255.0 alpha:1];
        _titleLabel.numberOfLines             = 0;
        _titleLabel.hidden                    = YES;
        _titleLabel.textAlignment             = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.baselineAdjustment        = UIBaselineAdjustmentAlignCenters;
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"Icon_NavigationBar_Back_Normal_White"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(15,8,12,63);
        _backButton.titleEdgeInsets = UIEdgeInsetsMake(15,0,11,23);
        _backButton.tag = ENavigationBarAction_Back;
        [_backButton addTarget:self action:@selector(composeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.hidden = self.backButtonHidden;

    }
    return _backButton;
}

- (UIButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] init];
        [_collectButton setImage:[UIImage imageNamed:@"Icon_NavigationBar_Collection_Normal_White"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"Icon_NavigationBar_Collection_Selected"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(composeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _collectButton.tag = ENavigationBarAction_Collect;
        _collectButton.hidden = self.collectButtonHidden;
    }
    return _collectButton;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:[UIImage imageNamed:@"Icon_NavigationBar_Share_Normal_White"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(composeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.tag = ENavigationBarAction_Share;
        _shareButton.hidden = self.shareButtonHidden;

    }
    return _shareButton;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        _bottomLineView.hidden = YES;
    }
    return _bottomLineView;
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden
{
    _backButtonHidden = backButtonHidden;
    _backButton.hidden = backButtonHidden;
}

- (void)setCollectButtonHidden:(BOOL)collectButtonHidden
{
    _collectButtonHidden = collectButtonHidden;
    _collectButton.hidden = collectButtonHidden;
}

- (void)setShareButtonHidden:(BOOL)shareButtonHidden
{
    _shareButtonHidden = shareButtonHidden;
    _shareButton.hidden = shareButtonHidden;
}

- (void)setSharedButtonIsSelected:(BOOL)sharedButtonIsSelected
{
    _sharedButtonIsSelected = sharedButtonIsSelected;
    _shareButton.selected = sharedButtonIsSelected;
}

@end
