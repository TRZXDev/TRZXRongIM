//
//  TRZXMapListViewController.m
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapListViewController.h"
#import "TRZXMapListViewModel.h"
#import "TRZXDIYRefresh.h"
#import "TRZXMapListCell.h"
#import "TRZXKit.h"

@interface TRZXMapListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mapListTableView;
@property (strong, nonatomic) TRZXMapListViewModel *mapListViewModel;
@end

@implementation TRZXMapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.mapListTableView];

    // Do any additional setup after loading the view.
}


-(void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate{

    self.mapListViewModel.currentCoordinate = currentCoordinate;
    self.mapListViewModel.centerCoordinate = currentCoordinate;
    [self refresh];


}


-(void)setTradeIds:(NSArray*)tradeIds stageIds:(NSArray *)stageIds{

    self.mapListViewModel.tradeIds = tradeIds;
    self.mapListViewModel.stageIds= stageIds;
    [self refresh];
    
}

-(void)setCity:(NSDictionary *)dic{

    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake([dic[@"latitude"] floatValue], [dic[@"longitude"] floatValue]);
    self.mapListViewModel.centerCoordinate = currentCoordinate;
    self.mapListViewModel.citycode = dic[@"citycode"];

    [self refresh];

}


- (void)refresh{

    self.mapListViewModel.willLoadMore = NO;
    [self.mapListTableView.mj_footer resetNoMoreData];
    [self requestSignal_toAll];
}

- (void)refreshMore{
    if (!self.mapListViewModel.canLoadMore) {
        [self.mapListTableView.mj_footer setState:MJRefreshStateNoMoreData];
        return;
    }
    self.mapListViewModel.willLoadMore = YES;
    [self requestSignal_toAll];
}

// 发起请求
- (void)requestSignal_toAll {


    [self.mapListViewModel.requestSignal_toAll subscribeNext:^(id x) {

        // 结束刷新状态
        if (self.mapListViewModel.willLoadMore) {
            [self.mapListTableView.mj_footer endRefreshing];
        }else{
            [self.mapListTableView.mj_header endRefreshing];
        }

        if (self.mapListViewModel.list.count<15){
            [self.mapListTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }

        // 请求完成后，更新UI

        [self.mapListTableView reloadData];

    } error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应提示

    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mapListViewModel.list.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TRZXMapListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TRZXMapListCell];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:kCellIdentifier_TRZXMapListCell owner:self options:nil] lastObject];
    }
    TRZXMapAnnotation *model = [self.mapListViewModel.list objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];



}


-(UITableView *)mapListTableView{
    if (!_mapListTableView) {
        // 内容视图
        _mapListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mapListTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        _mapListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mapListTableView.dataSource = self;
        _mapListTableView.delegate = self;
        _mapListTableView.estimatedRowHeight = 80;  //  随便设个不那么离谱的值
        _mapListTableView.rowHeight = UITableViewAutomaticDimension;
        // 去除顶部空白
        _mapListTableView.tableHeaderView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, 10)];;
        _mapListTableView.tableFooterView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];;
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        _mapListTableView.mj_header = [TRZXGifHeader headerWithRefreshingBlock:^{
            // 刷新数据
            [self refresh];
        }];
//        [_mapListTableView.mj_header beginRefreshing];

        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
        _mapListTableView.mj_footer = [TRZXGifFooter footerWithRefreshingBlock:^{
            [self refreshMore];

        }];
        _mapListTableView.mj_footer.automaticallyHidden = YES;



    }
    return _mapListTableView;
}
- (TRZXMapListViewModel *)mapListViewModel {

    if (!_mapListViewModel) {
        _mapListViewModel = [TRZXMapListViewModel new];
    }
    return _mapListViewModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
