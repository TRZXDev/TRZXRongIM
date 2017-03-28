//
//  JiaoYiJiLuViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/31.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "JiaoYiJiLuViewController.h"
#import "TRZXDVSwitch.h"
#import "EOWalletModel.h"
#import "EOWalletNoteTableViewCell.h"

#import "TRZXWalletMacro.h"

@interface JiaoYiJiLuViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)TRZXDVSwitch *switcher;
@property (strong, nonatomic)UITableView *myTableview;
@property (strong, nonatomic)NSMutableArray *bigDataArr;
@property (strong, nonatomic)NSArray *shouRuArr;
@property (strong, nonatomic)NSArray *zhiChuArr;
@property (strong, nonatomic)NSArray *allArr;
@property (copy, nonatomic)NSString *typeStr;
@end

@implementation JiaoYiJiLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _typeStr = @"all";
    _shouRuArr = [[NSArray alloc] init];
    _zhiChuArr = [[NSArray alloc] init];
    _allArr = [[NSArray alloc] init];
    _bigDataArr = [[NSMutableArray alloc] init];
    [self registerTitleLabe:@"交易记录"];
    [self topButtonView];
    
    _myTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-130)];
    _myTableview.delegate = self;
    _myTableview.dataSource = self;
    _myTableview.separatorStyle = UITableViewCellSelectionStyleNone;
    _myTableview.backgroundColor = WalletbackColor;
    _myTableview.showsHorizontalScrollIndicator = NO;
    _myTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableview];
    [self request_Api:@""];
    [self request_Api:@"in"];
    [self request_Api:@"out"];
    
}

- (void)request_Api:(NSString *)inOut {
    

    [EOMyWalletViewModel getWallet_RecordListPage:0 inOut:inOut Success:^(id responseObj) {
        
        if ([inOut isEqualToString:@"in"]) {
            _shouRuArr = [EOWalletRecordModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            
        } else if ([inOut isEqualToString:@"out"]) {
            _zhiChuArr = [EOWalletRecordModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            
        } else {
            _allArr = [EOWalletRecordModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        }
        [_myTableview reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)topButtonView {
    NSArray *itemArr = @[@"全部",@"收入",@"支出"];
    self.switcher = [[TRZXDVSwitch alloc] initWithStringsArray:itemArr];
    self.switcher.cornerRadius = 18;
    self.switcher.sliderOffset = 1.0;
    self.switcher.font = [UIFont systemFontOfSize:14];
    self.switcher.backgroundColor = [UIColor whiteColor];
    self.switcher.sliderColor = TRZXWalletMainColor;
    self.switcher.labelTextColorInsideSlider = [UIColor whiteColor];
    self.switcher.labelTextColorOutsideSlider = [UIColor lightGrayColor];
    //    self.navigationItem.titleView = self.switcher;
    [self.view addSubview:self.switcher];
    [self.switcher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(self.view.frame.size.width*0.9));
        make.height.equalTo(@(40));
    }];
    __weak __typeof(self)weakSelf = self;
    [self.switcher setPressedHandler:^(NSUInteger index) {
        if (index == 0) {
            _typeStr = @"all";
            [weakSelf.myTableview reloadData];
        }else if(index == 1) {
            _typeStr = @"in";
            [weakSelf.myTableview reloadData];
        } else {
            _typeStr = @"out";
            [weakSelf.myTableview reloadData];
        }
    }];
}

- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_typeStr isEqualToString:@"all"]) {
        return _allArr.count;
    } else if ([_typeStr isEqualToString:@"in"]) {
        return _shouRuArr.count;
    } else {
        return _zhiChuArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    EOWalletNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[TRZXWalletBundle loadNibNamed:@"EOWalletNoteTableViewCell" owner:self options:nil] lastObject];
    }
    if ([_typeStr isEqualToString:@"all"]) {
        EOWalletRecordModel *mode = [_allArr objectAtIndex:indexPath.row];
        cell.model = mode;
    }
    if ([_typeStr isEqualToString:@"in"]) {
        EOWalletRecordModel *mode = [_shouRuArr objectAtIndex:indexPath.row];
        cell.model = mode;
    }
    if ([_typeStr isEqualToString:@"out"]) {
        EOWalletRecordModel *mode = [_zhiChuArr objectAtIndex:indexPath.row];
        cell.model = mode;

    }
    return cell;

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
