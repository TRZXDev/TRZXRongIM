//
//  PleaseReceiveController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/22.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "PleaseReceiveController.h"
#import "TRZXPJiDuView.h"
#import "StudensWenTiCell.h"
#import "ChonghuayjnCell.h"
#import "RefuseController.h"
#import "CreateTimeController.h"


#import "SrudensDetailed.h"

#import "TRZXPersonalAppointmentPch.h"

@interface PleaseReceiveController ()<UITableViewDataSource,UITableViewDelegate>

{
    CGSize size;
    CGSize size2;
}

@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) TRZXPJiDuView *jinduView;

@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) UIButton *JieShouBtn;
@property (strong, nonatomic) UIButton *JuJueBtn;
@property (strong, nonatomic) SrudensDetailed *mode;
@end

@implementation PleaseReceiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请专家确认";
    [self request_Detailed];
    self.view.backgroundColor = backColor;
}

- (void)goBackView:(id)sender
{
    
    [self.delegate push1ZhuangTai];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)request_Detailed {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findInfo",
                             @"id":self.mid?self.mid:@""
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
    
        _mode = [SrudensDetailed mj_objectWithKeyValues:responseObj];
        [self topView];
        [self buttonView];
        
        [_myTableView reloadData];
    }];
}

- (void)topView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(66);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(WIDTH(self.view)));
        make.height.equalTo(@(25));
    }];
    
    UILabel *numberTitle = [[UILabel alloc] init];
    numberTitle.text = @"编号:";
    numberTitle.textColor = TRZXMainColor;
    numberTitle.font = [UIFont systemFontOfSize:10];
    [topView addSubview:numberTitle];
    [numberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.left.equalTo(topView.mas_left).offset(5);
        make.height.equalTo(@(25));
        make.width.equalTo(@(30));
    }];
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.font = [UIFont systemFontOfSize:10];
    _numberLable.text = _mode.data.orderId;
    [topView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.left.equalTo(topView.mas_left).offset(35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(150));
    }];
    
    _dateLable = [[UILabel alloc] init];
    _dateLable.text = _mode.data.createDate;
    _dateLable.font = [UIFont systemFontOfSize:10];
    [topView  addSubview:_dateLable];
    
    [_dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.right.equalTo(topView.mas_right).offset(-5);
        make.width.equalTo(@(60));
        make.height.equalTo(@(25));
    }];
    
    
    UILabel *dateTitle = [[UILabel alloc] init];
    dateTitle.text = @"发起时间:";
    dateTitle.textColor = TRZXMainColor;
    dateTitle.font = [UIFont systemFontOfSize:10];
    [topView addSubview:dateTitle];
    
    [dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.right.equalTo(_dateLable.mas_left);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
    }];
    
    
    _jinduView = [[TRZXPJiDuView alloc] initWithFrame:CGRectMake(0, 100, WIDTH(self.view), 12)];
    [_jinduView JiDuNow:2 with:5];
    [self.view addSubview:_jinduView];
    NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
    for (int i = 0; i<5; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 113, 50, 20)];
        lable.text = dataArr[i];
        lable.font = [UIFont systemFontOfSize:10];
                    if (i == 1) {
                        lable.textColor = TRZXMainColor;
                    } else {
        lable.textColor = [UIColor lightGrayColor];
                    }
    
        [self.view addSubview:lable];
    }
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, WIDTH(self.view),HEIGTH(self.view)-200)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = backColor;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
}

- (void)buttonView {
    _JuJueBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_JuJueBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [_JuJueBtn setTitleColor:zideColor forState:UIControlStateNormal];
    _JuJueBtn.backgroundColor = backColor;
    _JuJueBtn.layer.cornerRadius = 5;
    _JuJueBtn.layer.borderWidth = 0.8;
    _JuJueBtn.layer.borderColor = [xiandeColor CGColor];
    _JuJueBtn.tag = 100000;
    _JuJueBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_JuJueBtn addTarget:self action:@selector(btnClick_LGQ:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_JuJueBtn];
    
    [_JuJueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(8);
        make.height.equalTo(@(40));
        make.width.equalTo(@((WIDTH(self.view)-36)*0.3));
    }];
    
    _JieShouBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_JieShouBtn setTitle:@"接受" forState:UIControlStateNormal];
    [_JieShouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _JieShouBtn.backgroundColor = TRZXMainColor;
    _JieShouBtn.layer.cornerRadius = 5;
    _JieShouBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    _JieShouBtn.layer.borderWidth = 0.8;
//    _JieShouBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _JieShouBtn.tag = 200000;
    [_JieShouBtn addTarget:self action:@selector(btnClick_LGQ:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_JieShouBtn];
    
    [_JieShouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.equalTo(@(40));
        make.width.equalTo(@((WIDTH(self.view)-36)*0.7));
    }];
    
}


- (void)btnClick_LGQ:(UIButton *)sender
{
    if (sender.tag == 100000) {//拒绝
        _refuseVC = [[RefuseController alloc] init];
        _refuseVC.mid = self.mid;
        _refuseVC.meetStase = _mode.data.meetStatus;
        [self.navigationController pushViewController:_refuseVC animated:YES];
    } else {//接受
        _createTimeVC = [[CreateTimeController alloc] init];
        _createTimeVC.mid = self.mid;
        [self.navigationController pushViewController:_createTimeVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 204;
    } else if (indexPath.row == 1){
//        return 130;
//        StudensWenTiCell *cell = (StudensWenTiCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return size.height+85;
    } else {
//        StudensWenTiCell *cell = (StudensWenTiCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return size2.height+85;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *personalID = @"personalID";
        ChonghuayjnCell *cell = [tableView dequeueReusableCellWithIdentifier:personalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChonghuayjnCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImage.layer.cornerRadius = 6.0;
        cell.iconImage.layer.masksToBounds = YES;
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:_mode.data.stuPhoto] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        cell.nameLable.text = _mode.data.stuName;
        cell.moneyLable.text = [NSString stringWithFormat:@"%@元/次",_mode.data.muchOnce];
        cell.dateLable.text = [NSString stringWithFormat:@"约%@",_mode.data.timeOnce];
        cell.textLable.text = _mode.data.topicTitle;
        cell.backgroundColor = backColor;
        return cell;
    } else if (indexPath.row == 1){
        static NSString *StudenID = @"StudenID";
        StudensWenTiCell *cell = [tableView dequeueReusableCellWithIdentifier:StudenID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"StudensWenTiCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.WenTiLable.text = _mode.data.problem;
        cell.WenTiLable.numberOfLines = 0;
        cell.WenTiLable.lineBreakMode = NSLineBreakByWordWrapping;
        size = [cell.WenTiLable sizeThatFits:CGSizeMake(WIDTH(self.view)-32, MAXFLOAT)];
        cell.backgroundColor = backColor;
        return cell;
    
    } else {
        static NSString *StudenID = @"StudenID";
        StudensWenTiCell *cell = [tableView dequeueReusableCellWithIdentifier:StudenID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"StudensWenTiCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        cell.TitleLable.text = @"学员个人介绍";
        cell.WenTiLable.text = _mode.data.myIntroduce;
        cell.WenTiLable.numberOfLines = 0;
        cell.WenTiLable.lineBreakMode = NSLineBreakByWordWrapping;
        size2 = [cell.WenTiLable sizeThatFits:CGSizeMake(WIDTH(self.view)-32, MAXFLOAT)];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
