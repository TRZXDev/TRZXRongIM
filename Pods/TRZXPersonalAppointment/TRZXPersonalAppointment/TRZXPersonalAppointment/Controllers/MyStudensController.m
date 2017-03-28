//
//  MyStudensController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/12.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "MyStudensController.h"
#import "DVSwitch.h"
#import "ExpertCell.h"
#import "StudenCancelController.h"
#import "PleaseReceiveController.h"
#import "MyStudensMode.h"


#import "DaiFuKuanControllerViewController.h"
#import "YesEvaluateController.h"

#import "TRZXPersonalAppointmentPch.h"

@interface MyStudensController ()<UITableViewDataSource,UITableViewDelegate,DaifuKuanDelegate,zhuangtai1Delegate,zhuangtai5Delegate>

@property (strong, nonatomic)DVSwitch *switcher;

@property (strong, nonatomic)UITableView *LoadTableView;
@property (strong, nonatomic)UITableView *OverTableView;

@property (strong, nonatomic)UIView *zhongView;
@property (strong, nonatomic)UIView *wanchengView;

@property (strong, nonatomic)MyStudensMode *yueJianMode;
@property (strong, nonatomic)MyStudensMode *overMode;

@property (strong, nonatomic)NSString * switcherStr1;
@property (strong, nonatomic)NSString * switcherStr2;
@property (strong, nonatomic)UILabel *zwLabel;
@property (strong, nonatomic)UILabel *zwLabel1;
@property (strong, nonatomic)NSString * strUrl;

@end

@implementation MyStudensController
//-(void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//    [self BackInfo];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackInfo) name:NSNotificationMeet object:nil];
    self.title = @"我的约见";
    _strUrl = @"0";
    [self topButtonView];
    self.view.backgroundColor = backColor;
    _zhongView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, WIDTH(self.view), HEIGTH(self.view)-120)];
    _wanchengView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, WIDTH(self.view), HEIGTH(self.view)-120)];
    _zhongView.backgroundColor = backColor;
    _wanchengView.backgroundColor = backColor;
    [self.view addSubview:_zhongView];
    [self.view addSubview:_wanchengView];
    _LoadTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(_zhongView), HEIGTH(_zhongView))];
    _LoadTableView.delegate = self;
    _LoadTableView.dataSource = self;
    _LoadTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _LoadTableView.backgroundColor = backColor;
    _LoadTableView.showsHorizontalScrollIndicator = NO;
    _LoadTableView.showsVerticalScrollIndicator = NO;
    
    _LoadTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self BackInfo];
    }];
    [_zhongView addSubview:_LoadTableView];
    _OverTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(_wanchengView), HEIGTH(_wanchengView))];
    _OverTableView.delegate = self;
    _OverTableView.dataSource = self;
    _OverTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _OverTableView.backgroundColor = backColor;
    _OverTableView.showsHorizontalScrollIndicator = NO;
    _OverTableView.showsVerticalScrollIndicator = NO;
    
    _OverTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self BackInfo];
    }];
    [_wanchengView addSubview:_OverTableView];
    _zhongView.hidden = NO;
    _wanchengView.hidden = YES;
    [self zhuangtaiview];
    [self BackInfo];
}

- (void)BackInfo {
    if ([_strUrl isEqualToString:@"1"]) {
        _zhongView.hidden = YES;
        _wanchengView.hidden = NO;
        NSDictionary *params = @{
                                @"requestType":@"OtoSchoolMeet_Api",
                                @"apiType":@"findPageTeacher",
                                @"status":@"3"
                                };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
            //约见中
            
            _overMode = [MyStudensMode mj_objectWithKeyValues:responseObj];
            if ([_overMode.ingCount isEqual:@"0"]) {
                _zwLabel.text = @"";
            }else{
                _zwLabel.text = [NSString stringWithFormat:@"(%@)",_overMode.ingCount];
            }
            if ([_overMode.completeCount isEqual:@"0"]) {
                _zwLabel1.text = @"";
            }else{
                _zwLabel1.text = [NSString stringWithFormat:@"(%@)",_overMode.completeCount];
            }
            _overMode = [MyStudensMode mj_objectWithKeyValues:responseObj];
            if (_overMode.data.count>0) {
                
                _wanchengView.backgroundColor = backColor;
                _OverTableView.backgroundColor = backColor;
//                self.bgdImage.hidden = YES;
            }else{
                _wanchengView.backgroundColor = [UIColor clearColor];
                _OverTableView.backgroundColor = [UIColor clearColor];
//                self.bgdImage.hidden = NO;
            }
            [_OverTableView reloadData];
            [_OverTableView.mj_header endRefreshing];
            
        }];
    }else{
        _zhongView.hidden = NO;
        _wanchengView.hidden = YES;
        NSDictionary *params = @{
                                 @"requestType":@"OtoSchoolMeet_Api",
                                 @"apiType":@"findPageTeacher",
                                 @"status":@"1"
                                 };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
            //约见中
            
            _overMode = [MyStudensMode mj_objectWithKeyValues:responseObj];
            if ([_overMode.ingCount isEqual:@"0"]) {
                _zwLabel.text = @"";
            }else{
                _zwLabel.text = [NSString stringWithFormat:@"(%@)",_overMode.ingCount];
            }
            if ([_overMode.completeCount isEqual:@"0"]) {
                _zwLabel1.text = @"";
            }else{
                _zwLabel1.text = [NSString stringWithFormat:@"(%@)",_overMode.completeCount];
            }
            _yueJianMode = [MyStudensMode mj_objectWithKeyValues:responseObj];
            if (_yueJianMode.data.count>0) {
                
                _zhongView.backgroundColor = backColor;
                _LoadTableView.backgroundColor = backColor;
//                self.bgdImage.hidden = YES;
            }else{
                _zhongView.backgroundColor = [UIColor clearColor];
                _LoadTableView.backgroundColor = [UIColor clearColor];
//                self.bgdImage.hidden = NO;
            }
            [_LoadTableView reloadData];
            [_LoadTableView.mj_header endRefreshing];
            
            
        }];
    }
}
- (void)topButtonView {
    NSArray *itemArr = @[@"约见中",@"已完成"];
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
    self.switcher.labelTextColorOutsideSlider = [UIColor lightGrayColor];
    //    self.navigationItem.titleView = self.switcher;
    [self.view addSubview:self.switcher];
    [self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(75);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(WIDTH(self.view)*0.7));
        make.height.equalTo(@(35));
    }];
    
    zjself;
    [self.switcher setPressedHandler:^(NSUInteger index) {
        if (index == 0) {
            _strUrl = @"0";
            sfself.zwLabel.textColor = [UIColor whiteColor];
            sfself.zwLabel1.textColor = [UIColor lightGrayColor];
            [sfself BackInfo];
        }else {
            _strUrl = @"1";
            sfself.zwLabel.textColor = [UIColor lightGrayColor];
            sfself.zwLabel1.textColor = [UIColor whiteColor];
            [sfself BackInfo];
        }
    }];
}

- (void) zhuangtaiview
{
    _zwLabel = [[UILabel alloc]init];
    _zwLabel.font = [UIFont systemFontOfSize:(14)];
    
    _zwLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_zwLabel];
    [_zwLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(75);
        make.right.equalTo(self.view.mas_centerX).offset(-15);
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    _zwLabel1 = [[UILabel alloc]init];
    _zwLabel1.font = [UIFont systemFontOfSize:(14)];
    
    //    _zwLabel1.text = @"(1)";
    _zwLabel1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_zwLabel1];
    [_zwLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(75);
        make.right.equalTo(self.view.mas_right).offset(-(WIDTH(self.view)*0.3/2+15));
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    if ([_strUrl isEqualToString:@"0"]) {
        _zwLabel.textColor = [UIColor whiteColor];
        _zwLabel1.textColor = [UIColor lightGrayColor];
    } else {
        _zwLabel.textColor = [UIColor lightGrayColor];
        _zwLabel1.textColor = [UIColor whiteColor];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _LoadTableView) {
        return _yueJianMode.data.count;
    } else {
        return _overMode.data.count;
    }
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
    cell.typeSelf = @"studens";
    if (tableView == _LoadTableView) {
        StudenData *dataMode = [_yueJianMode.data objectAtIndex:indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dataMode.stuPhoto] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        cell.name.text = dataMode.stuName;
        if ([dataMode.isUpdated isEqual:@"0"]) {
            cell.zuixinImage.hidden = YES;
        }else{
            cell.zuixinImage.hidden = NO;
        }
        cell.money.text = [NSString stringWithFormat:@"%@元/次",dataMode.muchOnce];
        cell.time.text = [NSString stringWithFormat:@"约%@",dataMode.timeOnce];
        cell.text.text = dataMode.topicTitle;
        cell.meetState.text = [cell getMeetStatus:dataMode.meetStatus];
        if (dataMode.meetDate.length < 10) {
            
        } else {
            NSMutableString *mStr = [[NSMutableString alloc] initWithString:dataMode.meetDate];
            [mStr deleteCharactersInRange:NSMakeRange(6, 4)];
            cell.seeTime.text = mStr;
        }
        if (dataMode.meetStatus == 1) {
            cell.seeTime.text = @"未确认";
        }
        if (dataMode.meetStatus == 3) {
            cell.seeTime.text = @"未确认";
        }
        if (dataMode.meetStatus == 4) {
            cell.seeTime.text = @"未确认";
        }
        if (dataMode.meetStatus == 7) {
            cell.seeTime.hidden = YES;
            cell.seeTitle.hidden = YES;
            cell.money.hidden = YES;
            cell.time.hidden = YES;
            
        }
        
        
        
    } else {
        StudenData *dataMode = [_overMode.data objectAtIndex:indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:dataMode.stuPhoto] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        cell.name.text = dataMode.stuName;
        cell.money.text = [NSString stringWithFormat:@"%@元/次",dataMode.muchOnce];
        cell.time.text = dataMode.timeOnce;
        cell.text.text = dataMode.topicTitle;
        
        if ([dataMode.isUpdated isEqual:@"0"]) {
            cell.zuixinImage.hidden = YES;
        }else{
            cell.zuixinImage.hidden = NO;
        }
        if (dataMode.meetDate.length < 10) {
            
        } else {
            NSMutableString *mStr = [[NSMutableString alloc] initWithString:dataMode.meetDate];
            [mStr deleteCharactersInRange:NSMakeRange(6, 4)];
            cell.seeTime.text = mStr;
        }
        cell.meetState.text = [cell getMeetStatus:dataMode.meetStatus];
        if (dataMode.meetStatus == 2 || dataMode.meetStatus == 10 || dataMode.meetStatus == 12) {
            //            cell.meetState.text = @"已取消";
            cell.seeTime.hidden = YES;
            cell.seeTitle.hidden = YES;
        }
        if (dataMode.meetStatus == 5) {
            cell.seeTime.hidden = YES;
            cell.seeTitle.hidden = YES;
        }
        if (dataMode.meetStatus == 6) {
            cell.seeTime.hidden = YES;
            cell.seeTitle.hidden = YES;
        }
        if (dataMode.meetStatus == 9||dataMode.meetStatus == 10||dataMode.meetStatus == 11) {
            cell.money.hidden = YES;
            cell.time.hidden = YES;
            cell.seeTime.hidden = YES;
            cell.seeTitle.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _LoadTableView) {
        StudenData *dataMode = [_yueJianMode.data objectAtIndex:indexPath.row];
        dataMode.isUpdated = @"0";
//        ExpertCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.zuixinImage.hidden == NO) {
//            cell.zuixinImage.hidden = YES;
////            _switcherStr1 = [NSString stringWithFormat:@"约见中 (%d)",_yueJianMode.ingCount.intValue - 1];
////            NSArray *itemArr = @[_switcherStr1,_switcherStr2];
//            NSArray *itemArr = @[@"约见中",@"已完成"];
//            self.switcher = [[DVSwitch alloc] initWithStringsArray:itemArr];
//        }else
        if (dataMode.meetStatus == 1) {
            _PleaseReceiveVC = [[PleaseReceiveController alloc] init];
            _PleaseReceiveVC.mid = dataMode.mid;
            [self.navigationController pushViewController:_PleaseReceiveVC animated:YES];
        }else{
            DaiFuKuanControllerViewController *daiFuKuan = [[DaiFuKuanControllerViewController alloc] init];
            if (dataMode.meetStatus == 4) {//待学员选择时间
                daiFuKuan.vCType = @"DXYXZSJ";
            }else if (dataMode.meetStatus == 3){
                daiFuKuan.vCType = @"DXYFK";
            }else if ( dataMode.meetStatus == 13){
                daiFuKuan.vCType = @"DSFJM";
            }else if ( dataMode.meetStatus == 7){
                daiFuKuan.vCType = @"DPJ";
            }
            daiFuKuan.delegate = self;
            daiFuKuan.mid = dataMode.mid;
            [self.navigationController pushViewController:daiFuKuan animated:YES];
        }
    }
    
    if (tableView == _OverTableView) {
        StudenData *dataMode = [_overMode.data objectAtIndex:indexPath.row];
        dataMode.isUpdated = @"0";
//        ExpertCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.zuixinImage.hidden == NO) {
//            cell.zuixinImage.hidden = YES;
////            _switcherStr2 = [NSString stringWithFormat:@"已完成 (%d)",_yueJianMode.completeCount.intValue - 1];
////            NSArray *itemArr = @[_switcherStr1,_switcherStr2];
//            NSArray *itemArr = @[@"约见中",@"已完成"];
//            self.switcher = [[DVSwitch alloc] initWithStringsArray:itemArr];
//        }else
        if (dataMode.meetStatus == 9||dataMode.meetStatus == 11) {
            YesEvaluateController * _YesEvaluateVc = [[YesEvaluateController alloc] init];
            _YesEvaluateVc.superType = @"teacher";
            _YesEvaluateVc.mid = dataMode.mid;
            _YesEvaluateVc.delegate = self;
            [self.navigationController pushViewController:_YesEvaluateVc animated:YES];
        }else{
            DaiFuKuanControllerViewController *daiFuKuan = [[DaiFuKuanControllerViewController alloc] init];
            if (dataMode.meetStatus == 2 ){
                daiFuKuan.vCType = @"QX";
            }else if (dataMode.meetStatus == 10){
                daiFuKuan.vCType = @"XTQX";
            }else if (dataMode.meetStatus == 12){
                daiFuKuan.vCType = @"WTG";
            }else if (dataMode.meetStatus == 5){
                daiFuKuan.vCType = @"DTK";
            }else if (dataMode.meetStatus == 6){
                daiFuKuan.vCType = @"YTK";
            }
            daiFuKuan.mid = dataMode.mid;
            daiFuKuan.delegate = self;
            [self.navigationController pushViewController:daiFuKuan animated:YES];
        }
    }
}

#pragma mark - DaiFuKuanDelgate
- (void)changeTopVC
{
    [self BackInfo];
}
- (void)push1ZhuangTai
{
    _backStr = @"1";
    [self BackInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
