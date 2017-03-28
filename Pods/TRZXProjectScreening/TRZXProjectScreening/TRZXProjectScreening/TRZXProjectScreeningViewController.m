//
//  TRZXProjectScreeningViewController.m
//  TRZX
//
//  Created by 移动微 on 16/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXProjectScreeningViewController.h"
#import "TRZXProjectScreeningView.h"
#import "TRZXKit.h"
#import "Masonry.h"
#import "TRZXScreeningViewModel.h"
@interface TRZXProjectScreeningViewController ()

/**
 确定按钮
 */
@property(nonatomic, strong)UIButton *sureButton;

/**
 重置按钮
 */
@property(nonatomic, strong)UIButton *resetButton;

@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)TRZXProjectScreeningView *tradeView; // 领域
@property(nonatomic, strong)TRZXProjectScreeningView *stageView; // 阶段
@property (strong, nonatomic) TRZXScreeningViewModel *screeningViewModel;

@end

@implementation TRZXProjectScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.projectTitle;
    self.scrollView.hidden = YES;

    [self requestSignal_hotProject];
}




// 发起请求
- (void)requestSignal_hotProject {


    [self.screeningViewModel.requestSignal_screening subscribeNext:^(id x) {

        // 请求完成后，更新UI
        self.tradeView.trades = self.screeningViewModel.trades;//领域
        self.stageView.stages = self.screeningViewModel.stages;//阶段

        self.stageView.top = self.tradeView.height;
        CGFloat contentHeight = self.stageView.bottom;
        self.scrollView.contentSize = CGSizeMake(self.view.width, contentHeight);
        self.scrollView.hidden = NO;


    } error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应提示
        
    }];
}


#pragma mark - Action

/**
 确定按钮点击
 */
-(void)sureButtonDidClick:(UIButton *)button{
    
    if (self.confirmComplete) {
        self.confirmComplete([self.tradeView getMid],[self.stageView getMid]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 重置按钮点击
 */
-(void)resetButtonDidClick:(UIButton *)button{

    [self.tradeView reset];
    [self.stageView reset];
}

/**
 获取领域mid
 */
-(NSString *)getDomainMid{
    return [self.tradeView getMid];
}

/**
 获取阶段mid
 */
-(NSString *)getStageMid{
    return [self.stageView getMid];
}




#pragma mark - Properties
-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureButton.userInteractionEnabled = YES;


        [self.view addSubview:_sureButton];
        _sureButton.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.height.equalTo(self.resetButton);
            make.width.mas_equalTo(self.view.width * 0.6);
            make.trailing.equalTo(self.view);
        }];
    }
    return _sureButton;
}
-(UIButton *)resetButton{
    if (!_resetButton) {
        _resetButton = [[UIButton alloc]init];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(resetButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        _resetButton.userInteractionEnabled = YES;
        _resetButton.backgroundColor = [UIColor whiteColor];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [self.view addSubview:_resetButton];
        [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.height.mas_equalTo(49);
            make.width.mas_equalTo(self.view.width * 0.4);
        }];
    }
    return _resetButton;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.sureButton.mas_top);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
    }
    return _scrollView;
}

-(TRZXProjectScreeningView *)tradeView{
    if (!_tradeView) {

        TRZXProjectScreeningViewType viewType = [self.screeningType isEqualToString:@"0"] ? TRZXProjectScreeningViewTypeProjectStage : TRZXProjectScreeningViewTypeInvestorStage;
        _tradeView = [TRZXProjectScreeningView initWithType:viewType Frame:CGRectMake(0, 0, self.view.width, 0)];
        [self.scrollView addSubview:_tradeView];
    }
    return _tradeView;
}

// 阶段
-(TRZXProjectScreeningView *)stageView{
    if (!_stageView) {
        TRZXProjectScreeningViewType viewType = [self.screeningType isEqualToString:@"0"] ? TRZXProjectScreeningViewTypeProjectDomain : TRZXProjectScreeningViewTypeInvestorDomain;
        _stageView = [TRZXProjectScreeningView initWithType:viewType Frame:CGRectMake(0, 0, self.view.width, 0)];
        [self.scrollView addSubview:_stageView];
    }
    return _stageView;
}

- (TRZXScreeningViewModel *)screeningViewModel {

    if (!_screeningViewModel) {
        _screeningViewModel = [TRZXScreeningViewModel new];
    }
    return _screeningViewModel;
}

@end
