//
//  TRZXProjectDetailTableViewHeaderView.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXTableViewCoverHeaderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TRZXTableViewCoverHeaderView()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) TRZXNavigationBar *navigationBar;

@property (nonatomic, weak)   UIScrollView *scrollView;

@end

@implementation TRZXTableViewCoverHeaderView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    CGFloat headerHeight = ([[UIScreen mainScreen] bounds].size.width) * 3 / 4;
    self = [super initWithFrame:CGRectMake(0, 0, 0, headerHeight)];
    if (!self) return nil;
    
    self.scrollView = scrollView;
    
    [self addOwnViews];
    
    [self layoutFrameOfSubViews];
    
    [self receiveActions];
    
    return self;
}

- (void)addOwnViews
{
    [self addSubview:self.coverImageView];
    [self.scrollView.superview addSubview:self.navigationBar];
}

- (void)layoutFrameOfSubViews
{
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.scrollView.superview);
        make.height.mas_equalTo(64);
    }];
}

- (void)receiveActions
{
    @weakify(self);
    [RACObserve(self.scrollView, contentOffset) subscribeNext:^(id x) {
        @strongify(self);
        
        CGFloat y = self.scrollView.contentOffset.y;
        
        CGRect rect = self.frame;
        rect.origin.y = y;
        rect.size.height = CGRectGetHeight(rect) - y;
        self.coverImageView.frame = rect;
        
        [self.navigationBar makeNavigationBarIsShowWithContentOfsetY:y];
        
    }];
}

#pragma mark - <Setter/Getter>
- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.userInteractionEnabled = YES;
    }
    return _coverImageView;
}

- (TRZXNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[TRZXNavigationBar alloc] init];
    }
    return _navigationBar;
}

- (void)setOnNavigationBarActionBlock:(void (^)(ENavigationBarAction action, UIButton *button))onNavigationBarActionBlock
{
    _onNavigationBarActionBlock = onNavigationBarActionBlock;
    _navigationBar.onNavigationBarActionBlock = onNavigationBarActionBlock;
}

- (void)setBackButtonHidden:(BOOL)backButtonHidden
{
    _backButtonHidden = backButtonHidden;
    _navigationBar.backButtonHidden = backButtonHidden;
}

- (void)setCollectButtonHidden:(BOOL)collectButtonHidden
{
    _collectButtonHidden = collectButtonHidden;
    _navigationBar.collectButtonHidden = collectButtonHidden;
}

- (void)setShareButtonHidden:(BOOL)shareButtonHidden
{
    _shareButtonHidden = shareButtonHidden;
    _navigationBar.shareButtonHidden = shareButtonHidden;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _navigationBar.title = title;
}

- (void)setCoverImageUrl:(NSString *)coverImageUrl
{
    _coverImageUrl = coverImageUrl;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:coverImageUrl] placeholderImage:[UIImage imageNamed:@"Icon_NavigationBar_PlaceholderImage"]];
}

- (void)setSharedButtonIsSelected:(BOOL)sharedButtonIsSelected
{
    _sharedButtonIsSelected = sharedButtonIsSelected;
    _navigationBar.sharedButtonIsSelected = sharedButtonIsSelected;
}

@end
