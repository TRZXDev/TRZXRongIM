//
//  YesEvaluateController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "YesEvaluateController.h"
#import "TRZXPJiDuView.h"
#import "TRZXPStar.h"
#import "PersonalCell.h"
#import "EvaluateBelowCell.h"
#import "EvaluateCentreCell.h"
#import "ConsultView.h"
#import "TimeSiztView.h"
#import "ChonghuayjnCell.h"
#import "MyExpertViewController.h"
#import "MyStudensController.h"
#import "CTMediator+TRZXComplaint.h"
#import "TRZXPersonalAppointmentPch.h"


@interface YesEvaluateController ()<UITableViewDataSource,UITableViewDelegate,CellFeedbackDelegate,CellButtonDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)UIButton *backBttn;
@property (strong, nonatomic)UILabel *numberLable;
@property (strong, nonatomic)UILabel *dateLable;
@property (strong, nonatomic)TRZXPJiDuView *jinduView;
@property (strong, nonatomic) TRZXPStar *star;
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) ConsultView *conSultView;
@property (strong, nonatomic) TimeSiztView *timeSiztView;

@property (strong, nonatomic) NSString * vipStr;
@property (nonatomic, strong) NSString *appKey;
/// 自定义反馈界面配置，在创建反馈界面前设置
@property (nonatomic, strong, readwrite) NSDictionary *customPlist;
@property (nonatomic,strong)NSNumber *count;
//@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
//@property (nonatomic, assign) YWEnvironment environment;

@property (strong, nonatomic) MeetModel *meetModel;


@end

@implementation YesEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"已评价";
    [self request_Api];
    self.view.backgroundColor = backColor;
}


- (void)request_Api {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findInfo",
                             @"id":self.mid?self.mid:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
            if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]) {
            _meetModel = [MeetModel mj_objectWithKeyValues:responseObj[@"data"]];
            _vipStr = responseObj[@"vip"];
            [self topView];
            _dateLable.text = _meetModel.createDate;
            _numberLable.text = _meetModel.orderId;
            [self tableViewUI];
            
        }
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
    _numberLable.text = @"123321748264678412";
    [topView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(1);
        make.left.equalTo(topView.mas_left).offset(35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(150));
    }];
    
    _dateLable = [[UILabel alloc] init];
    _dateLable.text = @"2012.12.12";
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
//    [_jinduView JiDuNow:5 with:5];
    [_jinduView JiDuNow:5 with:5 andIsPass:@"1"];
    [self.view addSubview:_jinduView];
    NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
    for (int i = 0; i<5; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 113, 50, 20)];
        lable.text = dataArr[i];
        lable.font = [UIFont systemFontOfSize:10];
        if (i == 4) {
            lable.textColor = TRZXMainColor;
        } else {
            lable.textColor = heizideColor;
        }
        
        [self.view addSubview:lable];
    }
}

- (void)tableViewUI {
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, WIDTH(self.view), HEIGTH(self.view)-130)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = backColor;
    _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_myTableView];
    
    _conSultView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ConsultView" owner:self options:nil] lastObject];
    _conSultView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.27];
    _conSultView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view));
    _conSultView.hidden = YES;
    _conSultView.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.27];
    _conSultView.MyAlertView.frame = CGRectMake(8, HEIGTH(self.view)/2.0-80, WIDTH(self.view)-16, 150);
    _conSultView.lineView.frame = CGRectMake(8, 35, WIDTH(self.view)-32, 1);
    _conSultView.CancleBtn.frame = CGRectMake(WIDTH(self.view)-36, HEIGTH(self.view)/2.0-90, 20, 20);
    _conSultView.CancleBtn.layer.borderColor = [TRZXMainColor CGColor];
    _conSultView.texttView.frame = CGRectMake(8, 40, WIDTH(self.view)-32, 102);
    _conSultView.hidden = YES;
    [self.view addSubview:_conSultView];
    
    _timeSiztView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TimeSiztView" owner:self options:nil] lastObject];
    _timeSiztView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.27];
    _timeSiztView.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view));
    _timeSiztView.hidden = YES;
    _timeSiztView.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.27];
    
    _timeSiztView.TimeLable.frame = CGRectMake(10, 17, 50, 20);
    _timeSiztView.DateLable.frame = CGRectMake(80, 17, WIDTH(self.view)-90, 20);
    
    _timeSiztView.SiztLable.frame = CGRectMake(10, 91, 50, 20);
    
    _timeSiztView.TimeSizt_AlertView.frame = CGRectMake(8, HEIGTH(self.view)/2.0-80, WIDTH(self.view)-16, 150);
    _timeSiztView.LineView.frame = CGRectMake(8, 50, WIDTH(self.view)-32, 1);
    [_timeSiztView.textttView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeSiztView.TimeSizt_AlertView.mas_top).offset(93);
        make.left.equalTo(_timeSiztView.TimeSizt_AlertView.mas_left).offset(80);
        make.right.equalTo(_timeSiztView.TimeSizt_AlertView.mas_right).offset(-15);
        make.bottom.equalTo(_timeSiztView.TimeSizt_AlertView.mas_bottom).offset(-5);
//        make.height.equalTo(@(25));
//        make.width.equalTo(@(150));
    }];
    _timeSiztView.Sizt_CancleBtn.frame = CGRectMake(WIDTH(self.view)-36, HEIGTH(self.view)/2.0-85, 20, 20);
    _timeSiztView.Sizt_CancleBtn.layer.borderColor = [TRZXMainColor CGColor];
    [self.view addSubview:_timeSiztView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([self.superType isEqualToString:@"teacher"]) {
            return 204;
        } else {
            return 115;
        }
    } else if (indexPath.row == 1) {
        return 179;
    } else {
        return 165;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([_superType isEqualToString:@"teacher"]) {
            static NSString *PersonalID = @"ChongHuaID";
            ChonghuayjnCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
            if (!cell) {
                cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChonghuayjnCell" owner:self options:nil] lastObject];
            }
            cell.backgroundColor = backColor;
            cell.iconImage.layer.cornerRadius = 6.0;
            cell.iconImage.layer.masksToBounds = YES;
//            cell.model = _meetModel;
            cell.dateLable.text = [NSString stringWithFormat:@"约%@",_meetModel.timeOnce];
            cell.nameLable.text = _meetModel.stuName;
            if ([_vipStr isEqualToString:@"1"]&&[_vipPDStr isEqualToString:@"1"]) {
                cell.moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.vipPrice];
            }else{
                cell.moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.muchOnce];
            }
            cell.textLable.text = _meetModel.topicTitle;
            
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:_meetModel.stuPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return  cell;

        } else {
        static NSString *PersonalID = @"PersonalID";
        PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalCell" owner:self options:nil] lastObject];
        }
        cell.cellBackView.backgroundColor = moneyColor;
        cell.contentView.backgroundColor = backColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_superType isEqualToString:@"teacher"]) {
            cell.type = @"teacher";
        } else {
            cell.type = @"student";
        }
            cell.vipStr = _vipStr;
        cell.model = _meetModel;
        return cell;
        }
    } else if (indexPath.row == 1) {
        static NSString *PersonalID = @"PersonalID";
        EvaluateCentreCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"EvaluateCentreCell" owner:self options:nil] lastObject];
        }
        
        cell.contentView.backgroundColor = backColor;
        cell.CellBackView.backgroundColor = [UIColor whiteColor];
        if ([self.superType isEqualToString:@"teacher"]) {
            cell.CellTitleLable.text = @"学员对您的评价";
        }
        
        cell.remarkText.editable = NO;
        cell.CellTitleLable.textColor = TRZXMainColor;
        cell.FeedBtn.backgroundColor = backColor;
        cell.FeedBtn.layer.borderColor = [xiandeColor CGColor];
        [cell.FeedBtn setTitleColor:zideColor forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        _star= [[TRZXPStar alloc]initWithFrame:CGRectMake(20, 40, 130, 50)];
        //    star.empty_color = [UIColor whiteColor];
        _star.full_color = [UIColor yellowColor];
        _star.font_size = 25;
        int fen = [_meetModel.score intValue];
            _star.show_star = fen*20;
        //    Starmark = _dataMode.praiseCount;
        [cell.contentView addSubview:_star];
        cell.mode = _meetModel;
        
        return cell;
    } else {
        static NSString *PersonalID = @"PersonalID";
        EvaluateBelowCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"EvaluateBelowCell" owner:self options:nil] lastObject];
        }
        
        if ([_superType isEqualToString:@"teacher"]) {
            cell.jieShaoLable.text = @"学员介绍";
            cell.phoneLable.text = @"学员电话";
        } else {
            
        }

        
        cell.cellBackView.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = backColor;
        cell.CellTitleLable.textColor = TRZXMainColor;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
#pragma mark -userFeedBack

//用户反馈
- (void)feedbackDelegate
{

    UIViewController * vc = [[CTMediator sharedInstance]TRZXComplaint_TRZXComplaintViewController:@{@"type":@"1",@"targetId":@" ",@"userTitle":@" "}];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)TransmitType:(NSString *)str
{
    if ([str isEqualToString:@"ConsultBtn"]) {
        //        _conSultView.TitleLable.textColor = heizideColor;
        _conSultView.texttView.text = _meetModel.problem;
        if ([_superType isEqualToString:@"teacher"]) {
            _conSultView.TitleLable.text = @"学员的问题";
        } else {
            _conSultView.TitleLable.text = @"我请教的问题";

        }

        [self showConsultView];
    } else if ([str isEqualToString:@"Myintroduce"]) {
        
        if ([_superType isEqualToString:@"teacher"]) {
            _conSultView.TitleLable.text = @"学员的介绍";
        } else {
            _conSultView.TitleLable.text = @"我的个人介绍";
            
        }
        _conSultView.texttView.text = _meetModel.myIntroduce;
        [self showConsultView];
    } else if ([str isEqualToString:@"TimeSite"]) {
        _timeSiztView.DateLable.text = _meetModel.meetDate;
        _timeSiztView.SiztTile_lable.text = _meetModel.meetAddrName;
        _timeSiztView.textttView.text  = _meetModel.meetAddr;
        [self showSizt_TimeApi];
    
    } else {
        NSString * str1 = @"拨打电话";
        NSString * str2;
        if ([_superType isEqualToString:@"teacher"]) {
            str2 = _meetModel.stuMobile;
        } else {
            str2 = _meetModel.teacherMobile;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert show];
    }
}

- (void)showConsultView {
    _conSultView.hidden = NO;
}

- (void)showSizt_TimeApi {
    _timeSiztView.hidden = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果有多个alertView，需要通过tag值区分
    
    //一个警告框里通过buttonIndex来区分点击的是哪个按钮
    if (buttonIndex == 0) {
//        TRZXLog(@"取消按钮被点击");
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_meetModel.teacherMobile]]];
    }
}

- (void)goBackView:(id)sender
{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[MyExpertViewController class]]){
             MyExpertViewController* csController = (MyExpertViewController*)vc;
            [[NSNotificationCenter defaultCenter]postNotificationName:PushSunGoBack object:nil];
            [self.navigationController popToViewController:csController animated:YES];
            return;
        }
        if ([vc isKindOfClass:[MyStudensController class]]){
            MyStudensController* csController = (MyStudensController*)vc;
            [self.delegate push1ZhuangTai];
            [self.navigationController popToViewController:csController animated:YES];
            return;
        }
        
    }
//    MyStudensController * _YesEvaluateVc = [[MyStudensController alloc] init];
//    _YesEvaluateVc.backStr = @"1";
//        [self.delegate push1ZhuangTai];
//    [self.navigationController popToRootViewControllerAnimated:YES];
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
