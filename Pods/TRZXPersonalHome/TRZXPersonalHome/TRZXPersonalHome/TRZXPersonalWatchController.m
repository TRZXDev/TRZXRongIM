//
//  TRZXPersonalWatchController.m
//  TRZXPersonalWatch
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "TRZXPersonalWatchController.h"
#import "TRZXPersonalWatchModel.h"
#import "ZaixianerjiyedeCell.h"
#import "TRZXPInvestSeeCell.h"
#import "TRZXDIYRefresh.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"
//#import "TRZXPWatchViewMode.h"


#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]

@interface TRZXPersonalWatchController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TRZXPersonalWatchModel * personalWatchModel;
@property (strong, nonatomic) UILabel *noLabelView;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;
@property (strong, nonatomic) NSString *fenleiStr;
@property (strong, nonatomic) NSMutableArray * watchArr;

@property (nonatomic, strong) UIImageView * bgdImage;

@end

@implementation TRZXPersonalWatchController


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.delegate pushAllSetting];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view addSubview:self.bgdImage];
//    _bgdImage.hidden = YES;
//    [self refresh];
    
    self.title = _panduanStr;
    [self.view addSubview:self.tableView];
    _pageNo = 1;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _tableView.mj_footer.hidden = NO;
        _noLabelView.hidden = YES;
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:_pageNo refresh:1];
            
        }else{
            [_tableView.mj_footer endRefreshing];
            _tableView.tableFooterView = self.noLabelView;
            _noLabelView.hidden = NO;
            _tableView.mj_footer.hidden = YES;
        }
    }];
    _tableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
}

//- (void)refresh{
//    
//    self.personalWatchModel.willLoadMore = NO;
//    [self.tableView.mj_footer resetNoMoreData];
//    [self createData];}
//
//- (void)refreshMore{
//    if (!self.personalWatchModel.canLoadMore) {
//        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//        return;
//    }
//    self.personalWatchModel.willLoadMore = YES;
//    [self createData];
//}
//
//- (TRZXPWatchViewMode *)personalWatchModel {
//    
//    if (!_personalWatchModel) {
//        _personalWatchModel = [TRZXPWatchViewMode new];
//        _personalWatchModel.MID = self.MID;
//        _personalWatchModel.panduanStr = self.panduanStr;
//    }
//    return _personalWatchModel;
//}
//// 发起请求
//- (void)createData {
//    [self.personalWatchModel.requestSignal_list subscribeNext:^(id x) {
//        // 请求完成后，更新UI
//        [self.tableView.mj_header endRefreshing];
//        
//        [self.tableView reloadData];
//        
//    } error:^(NSError *error) {
//        // 如果请求失败，则根据error做出相应提示
//        [self.tableView.mj_header endRefreshing];
//        
//    }];
//}

-(UIImageView *)bgdImage{
    if (!_bgdImage) {
        
        _bgdImage = [[UIImageView alloc]init];
        _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
        _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
        
        
    }
    return _bgdImage;
}
-(UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backColor;
//        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//        _tableView.mj_header = [TRZXGifHeader headerWithRefreshingBlock:^{
//            // 刷新数据
//            [self refresh];
//        }];
//        [_tableView.mj_header beginRefreshing];
//        
//        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
//        _tableView.mj_footer = [TRZXGifFooter footerWithRefreshingBlock:^{
//            [self refreshMore];
//            
//        }];
//        _tableView.mj_footer.automaticallyHidden = YES;
        
        
    }
    return _tableView;
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        _fenleiStr = @"recodeCourse";
    }
    if ([_panduanStr isEqualToString:@"观看路演"]) {
        _fenleiStr = @"recodeRoadShow";
    }
    NSDictionary *params = @{@"requestType":@"User_Record_Api",
                             @"apiType":_fenleiStr,
                             @"beVisitId":_midStr?_midStr:@"",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        if ([object[@"status_code"] isEqualToString:@"200"]) {
            NSDictionary *personalArr = object[@"data"];
            _totalPage = [object[@"totalPage"] integerValue];
            
            if(refreshIndex==0){
                _watchArr = [[NSMutableArray alloc]initWithArray:[TRZXPersonalWatchModel mj_objectArrayWithKeyValuesArray:personalArr]];
                if (_watchArr.count>0) {
                    _tableView.tableFooterView = [[UIView alloc]init];
                    _tableView.mj_footer.hidden = NO;
                    _tableView.backgroundColor = backColor;
                    self.bgdImage.hidden = YES;
                    if(_totalPage<=1){
                        _tableView.tableFooterView = self.noLabelView;
                        
                        _noLabelView.hidden = NO;
                        _tableView.mj_footer.hidden = YES;
                    }else{
                        _tableView.mj_footer.hidden = NO;
                        _tableView.tableFooterView.hidden = YES;
                    }
                }else{
                    _tableView.mj_footer.hidden = YES;
                    _tableView.backgroundColor = [UIColor clearColor];
                    self.bgdImage.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
            }else{
                NSArray *array = [TRZXPersonalWatchModel mj_objectArrayWithKeyValuesArray:personalArr];
                if (array.count>0) {
                    [_watchArr addObjectsFromArray:array];
                    [_tableView.mj_footer endRefreshing];
                    
                }else{
                    _bgdImage.hidden = NO;
                    _tableView.mj_footer.hidden = YES;
                }
            }
            [_tableView reloadData];
        }else{
            _tableView.mj_footer.hidden = YES;
            _tableView.backgroundColor = [UIColor clearColor];
            _bgdImage.hidden = NO;
            
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.watchArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXPersonalWatchModel *mode = self.watchArr[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        return 134;
    }else{
        if (mode.projectId) {
            return 112;
        }else{
            return 102;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXPersonalWatchModel *mode = self.watchArr[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {
        ZaixianerjiyedeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZaixianerjiyedeCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZaixianerjiyedeCell" owner:self options:nil] lastObject];
        }
        self.tableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.titleLabel.text = mode.name;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:mode.userPic] placeholderImage:[UIImage imageNamed:@"展位图"]];
        NSString * companyPosition = [NSString stringWithFormat:@"  %@,%@  ",mode.company,mode.title];
        cell.kanguoLab.text = [NSString stringWithFormat:@"%@人看过",mode.clickRate];
        
        if(mode.title==nil){
            companyPosition = mode.user;
        }
        cell.backgroundColor = backColor;
        cell.nameLabel.text = mode.user;
        cell.positionLabel.text = companyPosition;
        
        
        return cell;
        
    }else {
        
        TRZXPInvestSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXPInvestSeeCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TRZXPInvestSeeCell" owner:nil options:nil]lastObject];
        }
        _tableView.showsVerticalScrollIndicator =
        NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        cell.headImageView.layer.cornerRadius = 6;
        cell.headImageView.layer.masksToBounds = YES;
        cell.bgView.layer.cornerRadius = 6;
        cell.bgView.layer.masksToBounds = YES;
        cell.titleLabel.text = mode.name;
        cell.tradeLabel.text = mode.tradeInfo;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:mode.logo] placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.detailLabel.text = mode.briefIntroduction;
        cell.detailLabel.hidden = YES;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TRZXPersonalWatchModel *mode = self.personalWatchModel.data[indexPath.row];
    if ([_panduanStr isEqualToString:@"观看课程"]) {

    }else{

    }
}
- (UILabel *)noLabelView{
    if (!_noLabelView) {
        _noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _noLabelView.text = @"— 没有更多了 —";
        _noLabelView.textAlignment = NSTextAlignmentCenter;
        _noLabelView.textColor = zideColor;
    }
    return _noLabelView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


