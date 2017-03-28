//
//  TRZXInvestorDetailViewController.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/7.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailViewController.h"
#import "TRZXInvestorDetailMacro.h"
#import "TRZXInvestorDetailTableViewCoverHeaderView.h"
#import <ZBCellConfig/ZBCellConfig.h>
#import "TRZXInvestorDetailViewModel.h"

/// model
#import "TRZXInvestorDetailModel.h"

/// cell
#import "TRZXInvestorDetailNoMsgTableViewCell.h"
#import "TRZXInvestorDetailLeftRightTextTableViewCell.h"
#import "TRZXInvestorBaseInfoTableViewCell.h"
#import "TRZXInvestorDetailOnlyTextTableViewCell.h"
#import "TRZXInvestorDetailCasesTableViewCell.h"
#import "TRZXInvestorDeatailCasesMoreTableViewCell.h"
#import "TRZXInvestorDetailInvestorsTableViewCell.h"

/// header
#import "TRZXInvestorDetailTextSectionHeader.h"

/// vc
#import "TRZXInvestorCasesViewController.h"

/// 组件
#import <TRZXShare/TRZXShareManager.h>

@interface TRZXInvestorDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TRZXInvestorDetailTableViewCoverHeaderView *tableViewHeaderView;

@property (nonatomic, strong) TRZXInvestorDetailViewModel *investorDetailVM;

/**
 存储 cell
 */
@property (nonatomic, strong) NSMutableArray <NSArray <ZBCellConfig *> *> *sectionArray;

@property (nonatomic, assign) BOOL isSelectedInvestor;

@end

@implementation TRZXInvestorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addOwnViews];
    
    [self layoutFrameOfSubViews];
    
    [self receiveActions];
    
    [self reloadData:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)addOwnViews
{
    [self.view addSubview:self.tableView];
}
- (void)layoutFrameOfSubViews
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tableView.tableHeaderView = self.tableViewHeaderView;
}
- (void)receiveActions
{
    @weakify(self);
    [_tableViewHeaderView setOnNavigationBarActionBlock:^(ENavigationBarAction action, UIButton *button) {
        @strongify(self);
        switch (action) {
            case ENavigationBarAction_Back:
                [self.navigationController popViewControllerAnimated:NO];
                break;
            case ENavigationBarAction_Share:
            {
                NSString *title= @"投融在线-带您走进资本市场";
                NSString *desc= @"股权融资全过程服务第三方平台，提高融资能力，获取融资渠道！";
                NSString * link= @"https://www.baidu.com/";
                
                
                OSMessage *msg=[[OSMessage alloc]init];
                msg.title= title;
                msg.desc= desc;
                msg.link= link;
                msg.image= [UIImage imageNamed:@"icon"];//缩略图
                
                
                [[TRZXShareManager sharedManager]showTRZXShareViewMessage:msg handler:^(TRZXShareType type) {
                    
                    NSLog(@">>>>>>>>投融好友");
                    
                }];
            }
                
            default:
                break;
        }
    }];
    
    [_tableViewHeaderView setCurrentSelectidIsInvestor:^(BOOL isSelectedInvestor) {
        @strongify(self);
        [self reloadData:isSelectedInvestor];
    }];
    
}
- (void)reloadData:(BOOL)isSelectedInvestor
{
    _isSelectedInvestor = isSelectedInvestor;
    
    if (isSelectedInvestor) {
        
        self.investorDetailVM.investorId = self.investorId;
        [self.investorDetailVM.requestSignal_InvestorDetail subscribeNext:^(id x) {
            
            [self configSubViews];
            
            // 配置 cell
            [self configSectionCells];
            
        } error:^(NSError *error) {
            
        }];
        
    }else {
        
        [self.investorDetailVM.requestSignal_Organizatioin subscribeNext:^(id x) {
            
            // 配置 cell
            [self configSectionCells];
            
        } error:^(NSError *error) {
            
            
        }];
        
    }
    
}

- (void)configSectionCells
{
    [self.sectionArray removeAllObjects];
    
    TRZXInvestorDetailModel *investorDetailModel = self.investorDetailVM.investorDetailModel;
    
    ZBCellConfig *noMessageCellConfig = [ZBCellConfig new];
    noMessageCellConfig.cellClass = [TRZXInvestorDetailNoMsgTableViewCell class];
    noMessageCellConfig.title = @"投资信息";
    noMessageCellConfig.sectionHeaderClass = [TRZXInvestorDetailTextSectionHeader class];
    noMessageCellConfig.showSectionHeaderInfoMethod = @selector(setTextString:);
    noMessageCellConfig.sectionHeaderHeight = 35;
    [self.sectionArray addObject:@[noMessageCellConfig]];
    
    NSMutableArray *leftRightTextCellConfigs = [NSMutableArray new];
    for (int i = 0; i <  investorDetailModel.data.investmentStages.count; i++) {
        ZBCellConfig *leftRightTextCellConfig = [ZBCellConfig new];
        leftRightTextCellConfig.cellClass = [TRZXInvestorDetailLeftRightTextTableViewCell class];
        leftRightTextCellConfig.showCellInfoMethod = @selector(setInvestmentStage:);
        leftRightTextCellConfig.title = @"投资阶段";
        [leftRightTextCellConfigs addObject:leftRightTextCellConfig];
    }
    [self.sectionArray addObject:leftRightTextCellConfigs];
    
    NSMutableArray *investorBaseInfoCellConfigs = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        ZBCellConfig *cellConfig = [ZBCellConfig new];
        cellConfig.title = @"投资基本信息";
        cellConfig.cellClass = [TRZXInvestorBaseInfoTableViewCell class];
        cellConfig.showCellInfoMethod = @selector(setInvestorData:indexPath:isInvestor:);
        [investorBaseInfoCellConfigs addObject:cellConfig];
    }
    [self.sectionArray addObject:investorBaseInfoCellConfigs];
    
    ZBCellConfig *investorDetailInfo = [ZBCellConfig new];
    investorDetailInfo.title = _isSelectedInvestor ? @"个人介绍" : @"机构简介";
    investorDetailInfo.cellClass = [TRZXInvestorDetailOnlyTextTableViewCell class];
    investorDetailInfo.showCellInfoMethod = @selector(setDetailString:);
    investorDetailInfo.showSectionHeaderInfoMethod = @selector(setTextString:);
    investorDetailInfo.sectionHeaderClass = [TRZXInvestorDetailTextSectionHeader class];
    investorDetailInfo.sectionHeaderHeight = 35;
    [self.sectionArray addObject:@[investorDetailInfo]];
    
    NSMutableArray *investorCases = [NSMutableArray new];
    for (int i = 0; i < (investorDetailModel.data.investmentCases.count > 5 ? 5 : investorDetailModel.data.investmentCases.count); i++) {
        ZBCellConfig *cellConfig = [ZBCellConfig new];
        cellConfig.cellClass = [TRZXInvestorDetailCasesTableViewCell class];
        cellConfig.title = [NSString stringWithFormat:@"投资案例(%ld)", investorDetailModel.data.investmentCases.count];
        cellConfig.showCellInfoMethod = @selector(setInvestmentCase:);
        cellConfig.showSectionHeaderInfoMethod = @selector(setTextString:);
        cellConfig.sectionHeaderClass = [TRZXInvestorDetailTextSectionHeader class];
        cellConfig.sectionHeaderHeight = 35;
        [investorCases addObject:cellConfig];
    }
    [self.sectionArray addObject:investorCases];
    
    if (investorDetailModel.data.investmentCases.count > 5) {
        ZBCellConfig *investorCasesMoreCellConfig = [ZBCellConfig new];
        investorCasesMoreCellConfig.cellClass = [TRZXInvestorDeatailCasesMoreTableViewCell class];
        investorCasesMoreCellConfig.title = @"查看更多";
        [self.sectionArray addObject:@[investorCasesMoreCellConfig]];
    }
    
    NSMutableArray *investors = [NSMutableArray new];
    for (int i = 0; i < investorDetailModel.data.orgUserAuthList.count; i++) {
        ZBCellConfig *cellConfig = [ZBCellConfig new];
        cellConfig.cellClass = [TRZXInvestorDetailInvestorsTableViewCell class];
        cellConfig.title = @"投资人";
        cellConfig.showCellInfoMethod = @selector(setOrgUserAuthList:);
        cellConfig.showSectionHeaderInfoMethod = @selector(setTextString:);
        cellConfig.sectionHeaderClass = [TRZXInvestorDetailTextSectionHeader class];
        cellConfig.sectionHeaderHeight = 35;
        [investors addObject:cellConfig];
    }
    [self.sectionArray addObject:investors];
    
    [_tableView reloadData];
}

- (void)configSubViews
{
    _tableViewHeaderView.model = _investorDetailVM.investorDetailModel;
}

#pragma mark - <UITableViewDelegate/DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCellConfig *cellConfig = self.sectionArray[indexPath.section][indexPath.row];
    
    TRZXInvestorDetailModel *investorDetailModel = self.investorDetailVM.investorDetailModel;
    
    UITableViewCell *cell = nil;
    
    if ([cellConfig isTitle:@"投资阶段"]){
        
        NSArray <InvestmentStages *> *investmentStages = investorDetailModel.data.investmentStages;
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[investmentStages[indexPath.row]] isNib:YES];
    }else if ([cellConfig isTitle:@"投资基本信息"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[investorDetailModel.data, indexPath, [NSNumber numberWithBool:_isSelectedInvestor]] isNib:YES];
        
    }else if ([cellConfig isTitle:_isSelectedInvestor ? @"个人介绍" : @"机构简介"]) {
        
        NSString *infoString = investorDetailModel.data.abstractz;
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[infoString] isNib:YES];
        
    }else if ([cellConfig.title rangeOfString:@"投资案例"].location !=NSNotFound) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[investorDetailModel.data.investmentCases[indexPath.row]] isNib:YES];
        
    }else if ([cellConfig isTitle:@"投资人"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[investorDetailModel.data.orgUserAuthList[indexPath.row]] isNib:YES];
        
    }else {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:nil isNib:YES];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionArray[section].firstObject.sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZBCellConfig *cellConfig = _sectionArray[section].firstObject;
    return [cellConfig sectionHederOfCellConfigWithTableView:tableView dataModels:@[cellConfig.title?cellConfig.title:@""] isNib:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCellConfig *cellConfig = self.sectionArray[indexPath.section][indexPath.row];
    
    TRZXInvestorDetailModel *investorDetailModel = self.investorDetailVM.investorDetailModel;
    
    if ([cellConfig isTitle:@"查看更多"]) {
        
        TRZXInvestorCasesViewController *investorCases_vc = [TRZXInvestorCasesViewController new];
        investorCases_vc.investmentCases = investorDetailModel.data.investmentCases;
        [self.navigationController pushViewController:investorCases_vc animated:YES];
        
    }else if ([cellConfig isTitle:@"投资人"]) {
        
        
        TRZXInvestorDetailViewController *investorDetail_vc = [TRZXInvestorDetailViewController new];
        investorDetail_vc.investorId = [investorDetailModel.data.orgUserAuthList[indexPath.row] mid];
        [self.navigationController pushViewController:investorDetail_vc animated:YES];
        
    }
}

#pragma mark - <Setter/Getter>
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        // 设置代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 设置背景色
//        _tableView.backgroundColor = kTRZXBGrayColor;
        // 自动计算cell高度
        _tableView.estimatedRowHeight = 120.0f;
        // iOS8 系统中 rowHeight 的默认值已经设置成了 UITableViewAutomaticDimension
        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedSectionHeaderHeight = 10;
        //        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        // 去除cell分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (TRZXInvestorDetailTableViewCoverHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[TRZXInvestorDetailTableViewCoverHeaderView alloc] initWithScrollView:_tableView];
    }
    return _tableViewHeaderView;
}

- (TRZXInvestorDetailViewModel *)investorDetailVM
{
    if (!_investorDetailVM) {
        _investorDetailVM = [[TRZXInvestorDetailViewModel alloc] init];
    }
    return _investorDetailVM;
}


- (NSMutableArray<NSArray<ZBCellConfig *> *> *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

@end
