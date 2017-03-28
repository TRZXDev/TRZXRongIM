//
//  TRZXProjectDetailViewController.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/2.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailViewController.h"
#import "TRZXProjectDetailMacro.h"
#import "TRZXProjectDetailTableViewCoverHeaderView.h"
#import "TRZXProjectDetailViewModel.h"

#import <ZBCellConfig/ZBCellConfig.h>

/// 各种 cell
#import "TRZXProjectDetailOnlyTextTableViewCell.h"
#import "TRZXProjectDetailLeftTitleRightInfoTableViewCell.h"
#import "TRZXProjectDetailFinancingInfoTableViewCell.h"
#import "TRZXProjectDetailProjectHistoryTableViewCell.h"
#import "TRZXProjectDetailAuthorTableViewCell.h"
#import "TRZXProjectDetailTeamTableViewCell.h"
#import "TRZXProjectDetailCommentTableViewCell.h"
#import "TRZXProjectDetailCommendTableViewCell.h"
#import "TRZXProjectDetailOnLineClassTableViewCell.h"
#import "TRZXProjectDetailnvestTableViewCell.h"

/// sectionHeader
#import "TRZXProjectDetailTitleSectionHeaderView.h"
#import "TRZXProjectDetailLeftRedTitleSectionHeaderView.h"

/// 评论列表
#import "TRZXProjectDetailCommentListView.h"

// 投资人详情扩展
#import <TRZXInvestorDetailCategory/CTMediator+TRZXInvestorDetailCategory.h>

/// 分享
#import <TRZXShare/TRZXShareManager.h>

@interface TRZXProjectDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

/**
 主tableView视图
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 tableView 头视图
 */
@property (nonatomic, strong) TRZXProjectDetailTableViewCoverHeaderView *tableViewHeaderView;
/**
 VM
 */
@property (nonatomic, strong) TRZXProjectDetailViewModel *projectDetailVM;

/**
 存储 cell
 */
@property (nonatomic, strong) NSMutableArray <NSArray <ZBCellConfig *> *> *sectionArray;

/**
 评论列表
 */
@property (nonatomic, strong) TRZXProjectDetailCommentListView *commentListView;

@end

@implementation TRZXProjectDetailViewController

#pragma mark - <生命周期>
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kTRZXBGrayColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addOwnViews];
    
    [self layoutFrameOfSubViews];
    
    [self receiveActions];
    
    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    // 设置header
    _tableView.tableHeaderView = self.tableViewHeaderView;
}

- (void)receiveActions
{
    @weakify(self);
    [_tableViewHeaderView setOnNavigationBarActionBlock:^(ENavigationBarAction action, UIButton *button) {
        @strongify(self);
        switch (action) {
            case ENavigationBarAction_Back: {
                [self.commentListView dissMiss];
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case ENavigationBarAction_Collect: {
                NSLog(@"ENavigationBarAction_Collect!");
            }
                
                break;
            case ENavigationBarAction_Share: {
                NSLog(@"ENavigationBarAction_Share!");
                
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
                
                break;
                
            default:
                break;
        }
    }];
}

- (void)configSubViews
{
    _tableViewHeaderView.model = self.projectDetailVM.projectDetailModel;
}

- (void)reloadData
{
    self.projectDetailVM.projectId = self.projectId;
    [self.projectDetailVM.requestSignal_projectDetail subscribeNext:^(id x) {
        
        // 配置子视图
        [self configSubViews];
        
        // 配置 cell
        [self configSectionCells];
        
        // 刷新列表
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - <Private-Method>
- (void)configSectionCells
{
    // ETableViewSection_ProjectBaseHeader
    ZBCellConfig *projectBaseHeaderCellConfig = [[ZBCellConfig alloc] init];
    projectBaseHeaderCellConfig.title = @"项目标题";
    projectBaseHeaderCellConfig.cellClass = [TRZXProjectDetailOnlyTextTableViewCell class];
    projectBaseHeaderCellConfig.showCellInfoMethod = @selector(setTextString:);
    [self.sectionArray addObject:@[projectBaseHeaderCellConfig]];
    
    // ETableViewSection_ProjectBaseSubInfo
    NSMutableArray <ZBCellConfig *> *subInfoSectionCells = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        ZBCellConfig *leftTitleRightInfoCellConfig = [[ZBCellConfig alloc] init];
        leftTitleRightInfoCellConfig.title = @"基本信息";
        leftTitleRightInfoCellConfig.cellClass = [TRZXProjectDetailLeftTitleRightInfoTableViewCell class];
        leftTitleRightInfoCellConfig.showCellInfoMethod = @selector(setModel:indexPath:);
        [subInfoSectionCells addObject:leftTitleRightInfoCellConfig];
    }
    [self.sectionArray addObject:subInfoSectionCells];
    
    // ETableViewSection_ProjectFinancingInfo
    ZBCellConfig *financingInfoCellConfig = [[ZBCellConfig alloc] init];
    financingInfoCellConfig.title = @"融资信息";
    financingInfoCellConfig.cellClass = [TRZXProjectDetailFinancingInfoTableViewCell class];
    financingInfoCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
    financingInfoCellConfig.showCellInfoMethod = @selector(setModel:);
    financingInfoCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
    financingInfoCellConfig.sectionHeaderHeight = 40;
    [self.sectionArray addObject:@[financingInfoCellConfig]];
    
    // ETableViewSection_ProjectDetail
    ZBCellConfig *projectDetailCellConfig = [[ZBCellConfig alloc] init];
    projectDetailCellConfig.title = @"项目详情";
    projectDetailCellConfig.cellClass = [TRZXProjectDetailOnlyTextTableViewCell class];
    projectDetailCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
    projectDetailCellConfig.showCellInfoMethod = @selector(setTextString:);
    projectDetailCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
    projectDetailCellConfig.sectionHeaderHeight = 40;
    [self.sectionArray addObject:@[projectDetailCellConfig]];
    
    // ETableViewSection_ProjectHistory
    NSMutableArray <ZBCellConfig *> *projectHistoryCells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _projectDetailVM.projectDetailModel.data.dynamicList.count; i++) {
        ZBCellConfig *projectHistoryCellConfig = [[ZBCellConfig alloc] init];
        projectHistoryCellConfig.title = @"项目大事记";
        projectHistoryCellConfig.cellClass = [TRZXProjectDetailProjectHistoryTableViewCell class];
        projectHistoryCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
        projectHistoryCellConfig.showCellInfoMethod = @selector(setModel:indexPath:);
        projectHistoryCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
        projectHistoryCellConfig.sectionHeaderHeight = 40;
        [projectHistoryCells addObject:projectHistoryCellConfig];
    }
    [self.sectionArray addObject:projectHistoryCells];
    
    // ETableViewSection_ProjectCreatePeople
    ZBCellConfig *projectCreatePeopleCellConfig = [ZBCellConfig new];
    projectCreatePeopleCellConfig.title = @"创始人";
    projectCreatePeopleCellConfig.cellClass = [TRZXProjectDetailAuthorTableViewCell class];
    projectCreatePeopleCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
    projectCreatePeopleCellConfig.showCellInfoMethod = @selector(setModel:);
    projectCreatePeopleCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
    projectCreatePeopleCellConfig.sectionHeaderHeight = 40;
    [self.sectionArray addObject:@[projectCreatePeopleCellConfig]];
    
    // ETableViewSection_Team
    NSMutableArray <ZBCellConfig *> *teamCells = [[NSMutableArray alloc] init];
    for (int i = 0; i < _projectDetailVM.projectDetailModel.data.teamList.count; i++) {
        ZBCellConfig *teamPeopleCellConfig = [ZBCellConfig new];
        teamPeopleCellConfig.title = @"核心团队";
        teamPeopleCellConfig.cellClass = [TRZXProjectDetailTeamTableViewCell class];
        teamPeopleCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
        teamPeopleCellConfig.showCellInfoMethod = @selector(setModel:);
        teamPeopleCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
        teamPeopleCellConfig.sectionHeaderHeight = 40;
        [teamCells addObject:teamPeopleCellConfig];
    }
    [self.sectionArray addObject:teamCells];
    
    // ETableViewSection_TeamDescribe
    ZBCellConfig *teamDescribeCellConfig = [ZBCellConfig new];
    teamDescribeCellConfig.title = @"团队概述";
    teamDescribeCellConfig.cellClass = [TRZXProjectDetailOnlyTextTableViewCell class];
    teamDescribeCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
    teamDescribeCellConfig.showCellInfoMethod = @selector(setTextString:);
    teamDescribeCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
    teamDescribeCellConfig.sectionHeaderHeight = 40;
    [self.sectionArray addObject:@[teamDescribeCellConfig]];
    
    // ETableViewSection_CompanyDescription
    ZBCellConfig *companyDescriptionCellConfig = [ZBCellConfig new];
    companyDescriptionCellConfig.title = @"公司简介";
    companyDescriptionCellConfig.cellClass = [TRZXProjectDetailOnlyTextTableViewCell class];
    companyDescriptionCellConfig.sectionHeaderClass = [TRZXProjectDetailTitleSectionHeaderView class];
    companyDescriptionCellConfig.showCellInfoMethod = @selector(setTextString:);
    companyDescriptionCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
    companyDescriptionCellConfig.sectionHeaderHeight = 40;
    [self.sectionArray addObject:@[companyDescriptionCellConfig]];
    
    // ETableViewSection_Comment
    ZBCellConfig *commentCellConfig = [ZBCellConfig new];
    commentCellConfig.title = @"评论";
    commentCellConfig.cellClass = [TRZXProjectDetailCommentTableViewCell class];
    commentCellConfig.showCellInfoMethod = @selector(setModel:);
    commentCellConfig.sectionHeaderHeight = 10;
    [self.sectionArray addObject:@[commentCellConfig]];
    
    // ETableViewSection_Commend
    ZBCellConfig *commedCellConfig = [ZBCellConfig new];
    commedCellConfig.cellClass = [TRZXProjectDetailCommendTableViewCell class];
    commedCellConfig.sectionHeaderHeight = 10;
    [self.sectionArray addObject:@[commedCellConfig]];
    
    // ETableViewSection_OnLineClass
    NSMutableArray <ZBCellConfig *> *onlineClassCellConfigs = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.projectDetailVM.recommendModel.coursezList.count; i++) {
        ZBCellConfig *onlineClassCellConfig = [ZBCellConfig new];
        onlineClassCellConfig.title = @"在线课程";
        onlineClassCellConfig.cellClass = [TRZXProjectDetailOnLineClassTableViewCell class];
        onlineClassCellConfig.sectionHeaderClass = [TRZXProjectDetailLeftRedTitleSectionHeaderView class];
        onlineClassCellConfig.showCellInfoMethod = @selector(setCoursezModel:);
        onlineClassCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
        onlineClassCellConfig.sectionHeaderHeight = 35;
        [onlineClassCellConfigs addObject:onlineClassCellConfig];
    }
    [self.sectionArray addObject:onlineClassCellConfigs];
    
    // ETableViewSection_OneToOne
    NSMutableArray <ZBCellConfig *> *oneToOneCellConfigs = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.projectDetailVM.recommendModel.expertTopicList.count; i++) {
        ZBCellConfig *oneToOneCellConfig = [ZBCellConfig new];
        oneToOneCellConfig.title = @"一对一咨询";
        oneToOneCellConfig.cellClass = [TRZXProjectDetailOnLineClassTableViewCell class];
        oneToOneCellConfig.sectionHeaderClass = [TRZXProjectDetailLeftRedTitleSectionHeaderView class];
        oneToOneCellConfig.showCellInfoMethod = @selector(setExpertTopicModel:);
        oneToOneCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
        oneToOneCellConfig.sectionHeaderHeight = 35;
        [oneToOneCellConfigs addObject:oneToOneCellConfig];
    }
    [self.sectionArray addObject:oneToOneCellConfigs];
    
    
    // ETableViewSection_InvestPeople
    NSMutableArray <ZBCellConfig *> *investPeopleCellConfigs = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.projectDetailVM.recommendModel.investorList.count; i++) {
        ZBCellConfig *investPeopleCellConfig = [ZBCellConfig new];
        investPeopleCellConfig.title = @"投资人";
        investPeopleCellConfig.cellClass = [TRZXProjectDetailnvestTableViewCell class];
        investPeopleCellConfig.sectionHeaderClass = [TRZXProjectDetailLeftRedTitleSectionHeaderView class];
        investPeopleCellConfig.showCellInfoMethod = @selector(setInvestorModel:);
        investPeopleCellConfig.showSectionHeaderInfoMethod = @selector(setTitle:);
        investPeopleCellConfig.sectionHeaderHeight = 35;
        [investPeopleCellConfigs addObject:investPeopleCellConfig];
    }
    [self.sectionArray addObject:investPeopleCellConfigs];
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
    
    ZBCellConfig *cellConfig = _sectionArray[indexPath.section][indexPath.row];
    
    UITableViewCell *cell = nil;
    
    TRZXProjectDetailModel *model = self.projectDetailVM.projectDetailModel;
    
    TRZXRecommendModel *recommedModel = self.projectDetailVM.recommendModel;
    
    
    if ([cellConfig isTitle:@"项目标题"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.briefIntroduction]];
        
    }else if ([cellConfig isTitle:@"基本信息"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data, indexPath]];
        
    }else if ([cellConfig isTitle:@"融资信息"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.projectFinancing]];
        
    }else if ([cellConfig isTitle:@"项目详情"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.projectAbs]];
        
    }else if ([cellConfig isTitle:@"项目大事记"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.dynamicList[indexPath.row], indexPath]];
        
    }else if ([cellConfig isTitle:@"创始人"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data] isNib:YES];
        
    }else if ([cellConfig isTitle:@"核心团队"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.teamList[indexPath.row]]];
        
    }else if ([cellConfig isTitle:@"团队概述"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.teamAdvantage]];
        
    }else if ([cellConfig isTitle:@"公司简介"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model.data.companyAbs]];
        
    }else if ([cellConfig isTitle:@"评论"]) {
        
        TRZXProjectDetailCommentTableViewCell *commentCell = (TRZXProjectDetailCommentTableViewCell *)[cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[model]];
        
        @weakify(self);
        [commentCell.moreLabelTapGesture.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            [self.commentListView showCommentList:self.projectDetailVM.projectDetailModel.commentsJson];
        }];
        
        cell = commentCell;
        
    }else if ([cellConfig isTitle:@"在线课程"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[recommedModel.coursezList[indexPath.row]]];
        
    }else if ([cellConfig isTitle:@"一对一咨询"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[recommedModel.expertTopicList[indexPath.row]]];
        
    }else if ([cellConfig isTitle:@"投资人"]) {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:@[recommedModel.investorList[indexPath.row]] isNib:YES];
    }else {
        
        cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModels:nil];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZBCellConfig *cellConfig = _sectionArray[section].firstObject;
    
    return [cellConfig sectionHederOfCellConfigWithTableView:tableView dataModels:@[cellConfig.title?cellConfig.title:@""] isNib:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _sectionArray[section].firstObject.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCellConfig *cellConfig = self.sectionArray[indexPath.section][indexPath.row];
    
    TRZXRecommendModel *recommedModel = self.projectDetailVM.recommendModel;
    
    if ([cellConfig isTitle:@"投资人"]) {
        NSString *investorId = recommedModel.investorList[indexPath.row].mid;
        
        UIViewController *investorDetail_vc = [[CTMediator sharedInstance] investorDetailViewController:investorId];
        
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
        _tableView.backgroundColor = kTRZXBGrayColor;
        // 自动计算cell高度
        _tableView.estimatedRowHeight = 80.0f;
        // iOS8 系统中 rowHeight 的默认值已经设置成了 UITableViewAutomaticDimension
        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedSectionHeaderHeight = 10;
//        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
//        _tableView.sectionFooterHeight = 0;
//        _tableView.estimatedSectionFooterHeight = UITableViewAutomaticDimension;
         // 去除cell分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (TRZXProjectDetailTableViewCoverHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[TRZXProjectDetailTableViewCoverHeaderView alloc] initWithScrollView:_tableView];
    }
    return _tableViewHeaderView;
}

- (TRZXProjectDetailViewModel *)projectDetailVM
{
    if (!_projectDetailVM) {
        _projectDetailVM = [[TRZXProjectDetailViewModel alloc] init];
    }
    return _projectDetailVM;
}

- (NSMutableArray<NSArray<ZBCellConfig *> *> *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}

- (TRZXProjectDetailCommentListView *)commentListView
{
    if (!_commentListView) {
        _commentListView = [TRZXProjectDetailCommentListView sharedCommentList];
    }
    return _commentListView;
}
@end
