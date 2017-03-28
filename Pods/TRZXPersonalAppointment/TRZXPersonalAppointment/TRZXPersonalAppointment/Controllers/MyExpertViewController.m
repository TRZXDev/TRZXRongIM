//
//  MyExpertViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "MyExpertViewController.h"
#import "DVSwitch.h"
#import "ExpertCell.h"
#import "LoadCountersignController.h"
#import "LoadEvaluateController.h"
#import "LoadPaymentController.h"

#import "MyExpertModel.h"
#import "LoadSeeController.h"
#import "YesEvaluateController.h"
#import "ChooseTimeController.h"
#import "MyStudensMode.h"

#import "TRZXPersonalAppointmentPch.h"

@interface MyExpertViewController () <UITableViewDataSource, UITableViewDelegate,zhuangtai1Delegate,zhuangtai3Delegate,zhuangtai2Delegate,zhuangtai4Delegate>

@property (strong, nonatomic)UIView *TopButtonView;
@property (strong, nonatomic)UIButton *meetBtn;
@property (strong, nonatomic)UIButton *evaluateBtn;
@property (strong, nonatomic)UIButton *overBtn;
@property (strong, nonatomic)DVSwitch *switcher;
@property (strong, nonatomic)UITableView *meetTableView;
@property (strong, nonatomic)UITableView *evaluateTableView;
@property (strong, nonatomic)UITableView *overTableView;
@property (strong, nonatomic)MyExpertModel *myExpertModel;
@property (strong, nonatomic)NSArray *cureentArray;
@property (strong, nonatomic)MyStudensMode *overMode;

//@property (strong, nonatomic)NSString * switcherStr1;
//@property (strong, nonatomic)NSString * switcherStr2;
//@property (strong, nonatomic)NSString * switcherStr3;

@property (strong, nonatomic)NSString *strUrl;

@property (strong, nonatomic)NSString *vipStr;
@property (strong, nonatomic)NSString *vipPDStr;

@property (strong, nonatomic)UILabel *zwLabel;
@property (strong, nonatomic)UILabel *zwLabel1;
@property (strong, nonatomic)UILabel *zwLabel2;

//记录跳转的字符串
@property(nonatomic,copy)NSString *LoadVC_TitleName;

@end

@implementation MyExpertViewController


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self requestFindPageByStudent:_status];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.title = @"我的约见";
     _strUrl = @"0";
    _status = @"1";
    [self topButtonView];
    [self jiazaipanduanView];
    [self tableView];
    // Do any additional setup after loading the view.

}



#pragma mark - 查询我的专家
- (void)jiazaipanduanView
{
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findPageByStudent",
                             @"status":@"1"
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        _vipStr = responseObj[@"vip"];

        _overMode = [MyStudensMode mj_objectWithKeyValues:responseObj];
        
        if ([_overMode.ingCount isEqual:@"0"]) {
            _zwLabel.text = @"";
            
        }else{
            _zwLabel.text = [NSString stringWithFormat:@"(%@)",_overMode.ingCount];
        }
        if ([_overMode.commentCount isEqual:@"0"]) {
            _zwLabel1.text = @"";
            
        }else{
            _zwLabel1.text = [NSString stringWithFormat:@"(%@)",_overMode.commentCount];
        }
        
        if ([_overMode.completeCount isEqual:@"0"]) {
            _zwLabel2.text = @"";
            
        }else{
            _zwLabel2.text = [NSString stringWithFormat:@"(%@)",_overMode.completeCount];
        }
       
    }];
}
- (void)requestFindPageByStudent:(NSString*)status
{
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findPageByStudent",
                             @"status":status?status:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
    
        if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]) {
            
            NSDictionary *dictArray  = responseObj[@"data"];
            _cureentArray = [MyExpertModel mj_objectArrayWithKeyValuesArray:dictArray];
            if (_cureentArray.count>0) {
                if ([_strUrl isEqualToString:@"0"]) {
                    [_meetTableView reloadData];
                }else if ([_strUrl isEqualToString:@"2"]) {
                    [_overTableView reloadData];
                }else{
                    [_evaluateTableView reloadData];
                }
                
//                self.bgdImage.hidden = YES;
                
            }else{
                
                if ([_strUrl isEqualToString:@"0"]) {
                    _meetTableView.backgroundColor = [UIColor clearColor];
                    _overTableView.backgroundColor = backColor;
                    _evaluateTableView.backgroundColor = backColor;
                    [_meetTableView reloadData];
                    
                }else if ([_strUrl isEqualToString:@"2"]) {
                    _meetTableView.backgroundColor = backColor;
                    _overTableView.backgroundColor = [UIColor clearColor];
                    _evaluateTableView.backgroundColor = backColor;
                    [_overTableView reloadData];
                    
                }else{
                    _meetTableView.backgroundColor = backColor;
                    _overTableView.backgroundColor = backColor;
                    _evaluateTableView.backgroundColor = [UIColor clearColor];
                    [_evaluateTableView reloadData];
                    
                }
//                self.bgdImage.hidden = NO;
            }
            
        }else{
            
        }
        [_meetTableView.mj_header endRefreshing];
        [_evaluateTableView.mj_header endRefreshing];
        [_overTableView.mj_header endRefreshing];
    }];
    
}
- (void) zhuangtaiview
{
    _zwLabel = [[UILabel alloc]init];
    _zwLabel.font = [UIFont systemFontOfSize:(14)];
    _zwLabel.textColor = [UIColor whiteColor];

    _zwLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_zwLabel];
    [_zwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(79);
        make.right.equalTo(self.view.mas_centerX).offset(-(WIDTH(self.view)*0.8/3/2+5));
        
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    _zwLabel1 = [[UILabel alloc]init];
    _zwLabel1.font = [UIFont systemFontOfSize:(14)];
    _zwLabel1.textColor = [UIColor lightGrayColor];
    
    //    _zwLabel1.text = @"(1)";
    _zwLabel1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_zwLabel1];
    [_zwLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(79);
        //        make.left.equalTo(self.view.mas_centerX).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-(WIDTH(self.view)*0.2/2+5+WIDTH(self.view)*0.8/3));
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    _zwLabel2 = [[UILabel alloc]init];
    _zwLabel2.font = [UIFont systemFontOfSize:(14)];
    _zwLabel2.textColor = [UIColor lightGrayColor];
    
    _zwLabel2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_zwLabel2];
    [_zwLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(79);
        //        make.left.equalTo(self.view.mas_centerX).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-(WIDTH(self.view)*0.2/2+5));
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    if ([_strUrl isEqualToString:@"0"]) {
        _zwLabel.textColor = [UIColor whiteColor];
        _zwLabel1.textColor = [UIColor lightGrayColor];
        _zwLabel2.textColor = [UIColor lightGrayColor];
    }else if ([_strUrl isEqualToString:@"1"]) {
        _zwLabel.textColor = [UIColor lightGrayColor];
        _zwLabel1.textColor = [UIColor whiteColor];
        _zwLabel2.textColor = [UIColor lightGrayColor];
    }else{
        _zwLabel.textColor = [UIColor lightGrayColor];
        _zwLabel1.textColor = [UIColor lightGrayColor];
        _zwLabel2.textColor = [UIColor whiteColor];
    }
}
- (void)topButtonView {


    NSArray *itemArr = @[@"约见中",@"待评价",@"已完成"];
    self.switcher = [[DVSwitch alloc] initWithStringsArray:itemArr];
    self.switcher.layer.cornerRadius = 16;
    self.switcher.layer.masksToBounds = YES;
    
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.switcher.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.switcher.layer.shouldRasterize = YES;

    self.switcher.sliderOffset = 1.0;
    self.switcher.font = [UIFont systemFontOfSize:14];
    self.switcher.backgroundColor = [UIColor whiteColor];
    self.switcher.sliderColor = TRZXMainColor;
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = zideColor;
    //    self.navigationItem.titleView = self.switcher;
    [self.view addSubview:self.switcher];
    [self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(WIDTH(self.view)*0.80));
        make.height.equalTo(@(35));
    }];
    //    注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushZhuangTai) name:PushSunGoBack object:nil];
    zjself;
    __block MyExpertViewController *mySelf = self;

    [self.switcher setPressedHandler:^(NSUInteger index) {

        _status = [NSString stringWithFormat:@"%lu",(unsigned long)index+1];

        if (index == 0) {
            _cureentArray = nil;
            [sfself tableViewOne];
//            _switcherStr03 = @"0";
            _strUrl = @"0";
            [mySelf requestFindPageByStudent:@"1"];
            mySelf.zwLabel.textColor = [UIColor whiteColor];
            mySelf.zwLabel1.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel2.textColor = [UIColor lightGrayColor];

        } else if (index == 1){
            _cureentArray = nil;
            [sfself tableViewTwo];
//            _switcherStr03 = @"1";
            _strUrl = @"1";
            [mySelf requestFindPageByStudent:@"2"];
            mySelf.zwLabel.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel1.textColor = [UIColor whiteColor];
            mySelf.zwLabel2.textColor = [UIColor lightGrayColor];
            
        } else {
            _cureentArray = nil;
            [sfself tableViewStree];
//            _switcherStr03 = @"2";
            _strUrl = @"2";
            [mySelf requestFindPageByStudent:@"3"];
            mySelf.zwLabel.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel1.textColor = [UIColor lightGrayColor];
            mySelf.zwLabel2.textColor = [UIColor whiteColor];
        }
    }];

    [self zhuangtaiview];
}

- (void)tableView{
    _meetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, WIDTH(self.view), HEIGTH(self.view)-130)];
    _meetTableView.dataSource = self;
    _meetTableView.delegate = self;
    _meetTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _meetTableView.backgroundColor = backColor;
    zjself;
    _meetTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [sfself requestFindPageByStudent:@"1"];
    }];

    _evaluateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, WIDTH(self.view), HEIGTH(self.view)-130)];
    _evaluateTableView.dataSource = self;
    _evaluateTableView.delegate = self;
    _evaluateTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _evaluateTableView.backgroundColor = backColor;
    _evaluateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [sfself requestFindPageByStudent:@"2"];
    }];

    _overTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, WIDTH(self.view), HEIGTH(self.view)-130)];
    _overTableView.dataSource = self;
    _overTableView.delegate = self;
    _overTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _overTableView.backgroundColor = backColor;
    _overTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [sfself requestFindPageByStudent:@"3"];
    }];
    [self tableViewOne];
    
}

- (void)tableViewOne {
    
    _evaluateTableView.hidden = YES;
    _overTableView.hidden = YES;
    [_evaluateTableView removeFromSuperview];
    [_overTableView removeFromSuperview];
    _meetTableView.hidden = NO;
    [self.view addSubview:_meetTableView];
    
}

- (void)tableViewTwo{
    _evaluateTableView.hidden = NO;
    _meetTableView.hidden = YES;
    _overTableView.hidden = YES;
    [_meetTableView removeFromSuperview];
    [_overTableView removeFromSuperview];
    [self.view addSubview:_evaluateTableView];
}

- (void)tableViewStree{
    _overTableView.hidden = NO;
    _meetTableView.hidden = YES;
    _evaluateTableView.hidden = YES;
    [_meetTableView removeFromSuperview];
    [_evaluateTableView removeFromSuperview];
    [self.view addSubview:_overTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cureentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 159;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *expertCellID = @"expertCellID";
    ExpertCell *cell = [tableView dequeueReusableCellWithIdentifier:expertCellID];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ExpertCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = backColor;
    cell.meetState.textColor = moneyColor;
    cell.seeTime.textColor = moneyColor;
    cell.vipStr = _vipStr;
    cell.typeSelf = @"expert";
    MyExpertModel *model = _cureentArray[indexPath.row];
    cell.model = model;
    if (model.meetStatus == 2 || model.meetStatus == 10 || model.meetStatus == 12 || model.meetStatus == 6 || model.meetStatus == 5) {
        //            cell.meetState.text = @"已取消";
        cell.seeTime.hidden = YES;
        cell.seeTitle.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyExpertModel *model = _cureentArray[indexPath.row];

    if (tableView == _meetTableView) {
        /*********等待页面*************/
//        _loadController = [[LoadCountersignController alloc] init];
//        _loadController.superType = @"meet";
//        [self.navigationController pushViewController:_loadController animated:YES];
        ExpertCell *expertCell = [tableView cellForRowAtIndexPath:indexPath];
        if (model.meetStatus == 1) {
            _loadController = [[LoadCountersignController alloc] init];
            _loadController.superType = @"meet";
            _loadController.conventionId = model.mid;
            _loadController.delegate = self;
            _loadController.titleName = expertCell.meetState.text;
            [self.navigationController pushViewController:_loadController animated:YES];
        }
        if (model.meetStatus == 3) {
            /********付款页面*************/
            _LoadPaymentController = [[LoadPaymentController alloc] init];
            _LoadPaymentController.conventionId = model.mid;
            _LoadPaymentController.delegate = self;
            [self.navigationController pushViewController:_LoadPaymentController animated:YES];
        }
        
        if (model.meetStatus == 13) {
            LoadSeeController *loadSeeVC = [[LoadSeeController alloc] init];
            loadSeeVC.mid = model.mid;
            [self.navigationController pushViewController:loadSeeVC animated:YES];
        }
        if (model.meetStatus == 4) {
            ChooseTimeController *chooseTime = [[ChooseTimeController alloc] init];
            chooseTime.meetId = model.mid;
            [self.navigationController pushViewController:chooseTime animated:YES];
        }

    }
    
    if (tableView == _evaluateTableView) {
        if (model.meetStatus == 7) {
            _LoadEvaluateController = [[LoadEvaluateController alloc] init];
            _LoadEvaluateController.mid = model.mid;
            _LoadEvaluateController.delegate = self;
            [self.navigationController pushViewController:_LoadEvaluateController animated:YES];
        }
        
    }
    
    if (tableView == _overTableView) {
        
        ExpertCell *expertCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (model.meetStatus == 9||model.meetStatus == 11) {
           _zhaungtaiVC = [[YesEvaluateController alloc] init];
            _zhaungtaiVC.superType = @"student";
            _zhaungtaiVC.vipPDStr = @"1";
            _zhaungtaiVC.mid = model.mid;
            _zhaungtaiVC.delegate = self;
            _zhaungtaiVC.zhuanjiaZT = @"1";
            _zhaungtaiVC.titleStr = expertCell.meetState.text;
            _loadController.titleName = expertCell.meetState.text;
            [self.navigationController pushViewController:_zhaungtaiVC animated:YES];
        }else {
            _loadController = [[LoadCountersignController alloc] init];
            if (model.meetStatus == 10){
                _loadController.superType = @"10";
            }else if (model.meetStatus == 12){
                _loadController.superType = @"12";
            }else if (model.meetStatus == 6){
                _loadController.superType = @"loadRefundLGQ";
            }else if (model.meetStatus == 5){
                _loadController.superType = @"loadRefund";
            }else{
                _loadController.superType = @"over";
            }
            
            _loadController.conventionId = model.mid;
            _loadController.delegate = self;
            _loadController.titleName = expertCell.meetState.text;
            [self.navigationController pushViewController:_loadController animated:YES];
        }
    }
}

- (void)push1ZhuangTai
{
    _backStr = @"1";
    [self jiazaipanduanView];
}

- (void)pushZhuangTai
{
    [self jiazaipanduanView];
    [self.switcher forceSelectedIndex:2 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
