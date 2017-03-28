//
//  ChooseTimeController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "ChooseTimeController.h"
#import "ChoosetimeCell.h"
#import "LoadSeeController.h"
#import "ChooseMode.h"
#import "TRZXPersonalAppointmentPch.h"


@interface ChooseTimeController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;

@property (weak, nonatomic) ChoosetimeCell *oldCell;

@property (strong, nonatomic) ChooseMode *mode;

@property (copy, nonatomic) NSString *mid;

@end

@implementation ChooseTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择约见时段";
    self.view.backgroundColor = backColor;
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"选择专家提出时间与地点,快速约见";
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor blackColor];
    [self.view addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(74);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(20));
        make.width.equalTo(@(250));
    }];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, WIDTH(self.view), HEIGTH(self.view)-104)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    
    [self request_Api];
}

- (void)request_Api {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeetDateAddr_Api",
                             @"apiType":@"findListByMeetId",
                             @"meetId":self.meetId?self.meetId:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        _mode = [ChooseMode mj_objectWithKeyValues:object];
        [_myTableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_mode.data.count) {
        return 0;
    } else {
        return _mode.data.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _mode.data.count) {
        return 45;
    } else {
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != _mode.data.count) {
        static NSString *CellID = @"CellID";
        ChoosetimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChoosetimeCell" owner:self options:nil] lastObject];
        }
        ChooseData *datamode = [_mode.data objectAtIndex:indexPath.row];
        cell.CellBackView.backgroundColor = moneyColor;
        cell.guanBiBtn.hidden = YES;
        cell.NumberLable.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.TimeLable.text = datamode.meetDate;
        cell.SiztTitleLable.text = datamode.meetAddrName;
        cell.SiztDetails.text = datamode.meetAddr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *CellID = @"btnCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
            UIButton *btnCell = [UIButton buttonWithType:UIButtonTypeSystem];
            btnCell.frame = CGRectMake(8, 5, WIDTH(self.view)-16, 40);
            [btnCell setTitle:@"确认" forState:UIControlStateNormal];
            [btnCell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnCell.backgroundColor = TRZXMainColor;
            btnCell.layer.cornerRadius = 10.0;
            [btnCell addTarget:self action:@selector(ConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != _mode.data.count) {
        
        _oldCell.CellBackView.backgroundColor = moneyColor;
        ChoosetimeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ChooseData *datamode = [_mode.data objectAtIndex:indexPath.row];
        _mid = datamode.mid;
        cell.CellBackView.backgroundColor = TRZXMainColor;
        _oldCell = cell;
    } else {
        
        
    }
}

- (void)ConfirmBtn:(UIButton *)sender
{
    if (!_mid.length) {
//        [LCProgressHUD showInfoMsg:@"请选择时间与地点"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择时间与地点" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSDictionary *params = @{
                                 @"requestType":@"OtoSchoolMeetDateAddr_Api",
                                 @"apiType":@"confirmDateAddr",
                                 @"id":_mid?_mid:@""
                                 };
        
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                _loadSeeVC = [[LoadSeeController alloc] init];
                _loadSeeVC.mid = self.meetId;
                _loadSeeVC.wodelyStr = @"wodelyStr";
                [self.navigationController pushViewController:_loadSeeVC animated:YES];
            }
        }];
    }
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


