//
//  TRZXInvestorCasesViewController.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorCasesViewController.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailCasesTableViewCell.h"

@interface TRZXInvestorCasesViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation TRZXInvestorCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"投资案例";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TRZXInvestorDetailCasesTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TRZXInvestorDetailCasesTableViewCell class])];
    
}
#pragma mark - <UITableViewDelegate/DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.investmentCases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXInvestorDetailCasesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TRZXInvestorDetailCasesTableViewCell class]) forIndexPath:indexPath];
    cell.investmentCase = self.investmentCases[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
#pragma mark - <Private-Method>
- (void)composeButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <Setter/Getter>
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // 设置代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置背景色
        //        _tableView.backgroundColor = kTRZXBGrayColor;
        // 自动计算cell高度
        _tableView.estimatedRowHeight = 80.0f;
//         iOS8 系统中 rowHeight 的默认值已经设置成了 UITableViewAutomaticDimension
        _tableView.rowHeight = UITableViewAutomaticDimension;
//                _tableView.estimatedSectionHeaderHeight = 30;
//                _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        // 去除cell分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        [_backButton setImage:[UIImage imageNamed:@"Icon_ProjectDetail_Back_Normal_Gray"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(2,0,0,3);
        _backButton.titleEdgeInsets = UIEdgeInsetsMake(3,0,0,0);
        [_backButton addTarget:self action:@selector(composeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


@end
