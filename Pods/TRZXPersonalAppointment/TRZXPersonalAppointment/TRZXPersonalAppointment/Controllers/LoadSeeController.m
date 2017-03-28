//
//  LoadSeeController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "LoadSeeController.h"
#import "TRZXPJiDuView.h"
#import "CancelViewController.h"
#import "MeetModel.h"

#import "EvaluateBelowCell.h"
#import "conSultView.h"
#import "TimeSiztView.h"

#import "TRZXPersonalAppointmentPch.h"


@interface LoadSeeController ()<CellButtonDelegate>

{
    UIButton *changeBtn;
}
@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) UIImageView *icimage;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *moneyLable;
@property (strong, nonatomic)UILabel *timeLable;
@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) MeetModel *meetModel;
@property (strong, nonatomic) TRZXPJiDuView *jinduView;

@property (strong, nonatomic) ConsultView *conSultView;
@property (strong, nonatomic) TimeSiztView *timeSiztView;

@end

@implementation LoadSeeController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    changeBtn.userInteractionEnabled = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backColor;
    self.title = @"待双方见面";
    
    [self requestFindInfo];
}

#pragma mark - 查询约见信息

- (void)requestFindInfo
{
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findInfo",
                             @"id":self.mid?self.mid:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
            if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]) {
            _meetModel = [MeetModel mj_objectWithKeyValues:responseObj[@"data"]];
            NSString*vipStr = responseObj[@"vip"];
            
            [self topView];
            [self cellView];
            [self createButton];
            _dateLable.text = _meetModel.createDate;
            _numberLable.text = _meetModel.orderId;
            _nameLable.text = _meetModel.teacherName;
            if ([vipStr isEqualToString:@"1"]) {
                _moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.vipPrice];
            }else{
                _moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.muchOnce];
            }
            _timeLable.text =[NSString stringWithFormat:@"约%@",_meetModel.timeOnce];
            _textLable.text = _meetModel.topicTitle;
            
            [_icimage sd_setImageWithURL:[NSURL URLWithString:_meetModel.teacherPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            
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
        [_jinduView JiDuNow:4 with:5];
        [self.view addSubview:_jinduView];
        NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
        for (int i = 0; i<5; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 113, 50, 20)];
            lable.text = dataArr[i];
            lable.font = [UIFont systemFontOfSize:10];
            if (i == 3) {
                lable.textColor = TRZXMainColor;
            } else {
                lable.textColor = heizideColor;
            }
            
            [self.view addSubview:lable];
        }
    
    
    
}

- (void)cellView {
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = moneyColor;
    cellView.layer.cornerRadius = 10;
    cellView.layer.masksToBounds = YES;
    [self.view addSubview:cellView];
    [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(105));
    }];
    
    _icimage = [[UIImageView alloc] init];
    _icimage.layer.cornerRadius = 6;
    _icimage.layer.masksToBounds = YES;
    [cellView addSubview:_icimage];
    [_icimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(15);
        make.left.equalTo(cellView.mas_left).offset(25);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.text = @"";
    _nameLable.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:_nameLable];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(70);
        make.centerX.equalTo(_icimage.mas_centerX);
        //        make.left.equalTo(cellView.mas_left);
        make.width.equalTo(@(85));
        make.height.equalTo(@(30));
    }];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.textColor = [UIColor whiteColor];
    _timeLable.text = @"约1.5个小时";
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:_timeLable];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(20);
        make.right.equalTo(cellView.mas_right).offset(-30);
        make.height.equalTo(@(15));
        make.width.equalTo(@(80));
    }];
    
    _moneyLable = [[UILabel alloc] init];
    _moneyLable.textColor = [UIColor whiteColor];
    _moneyLable.text = @"300元/次";
    _moneyLable.textAlignment = NSTextAlignmentRight;
    _moneyLable.font = [UIFont systemFontOfSize:13];
    [cellView addSubview:_moneyLable];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(20);
        make.right.equalTo(_timeLable.mas_left);
        make.height.equalTo(@(15));
        make.width.equalTo(@(80));
    }];
    
    _textLable = [[UILabel alloc] init];
    _textLable.text = @"我我我我我我我哦我我我哦喔喔喔喔喔我";
    _textLable.textAlignment = NSTextAlignmentJustified;
    _textLable.textColor = [UIColor whiteColor];
    _textLable.numberOfLines = 2;
    _textLable.font = [UIFont boldSystemFontOfSize:17];
    [cellView addSubview:_textLable];
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellView.mas_top).offset(40);
        make.left.equalTo(cellView.mas_left).offset(100);
        make.right.equalTo(cellView.mas_right).offset(-30);
        //        make.height.equalTo(@(50));
    }];
    
}

- (void)createButton {
    changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeBtn.frame = CGRectMake(10, 285, WIDTH(self.view)/2.0-20, 40);
    [changeBtn setTitle:@"私聊" forState:UIControlStateNormal];
    [changeBtn setTitleColor:grayKColor forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    changeBtn.layer.cornerRadius = 20;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.borderWidth = 1;
    changeBtn.layer.borderColor = grayKColor.CGColor;
    [changeBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.tag = 11111;
    [self.view addSubview:changeBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(WIDTH(self.view)/2.0+10, 285, WIDTH(self.view)/2.0-20, 40);
    [cancelBtn setTitle:@"取消约见" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:grayKColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelBtn.layer.cornerRadius = 20;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [grayKColor CGColor];
    [cancelBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 22222;
    [self.view addSubview:cancelBtn];
    
    [self createBottomView];
}

- (void)createBottomView
{
    EvaluateBelowCell *cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"EvaluateBelowCell" owner:self options:nil] firstObject];
    cell.CellTitleLable.text = @"约见信息";
    cell.frame = CGRectMake(10, 285 +40 +30, WIDTH(self.view)-20, 165);
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    cell.delegate = self;
    [self.view addSubview:cell];
    
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

- (void)TransmitType:(NSString *)str
{
    if ([str isEqualToString:@"ConsultBtn"]) {
        _conSultView.texttView.text = _meetModel.problem;
            _conSultView.TitleLable.text = @"我请教的问题";
        [self showConsultView];
        
    } else if ([str isEqualToString:@"Myintroduce"]) {
        _conSultView.TitleLable.text = @"我的个人介绍";
        _conSultView.texttView.text = _meetModel.myIntroduce;
        [self showConsultView];
        
    } else if ([str isEqualToString:@"TimeSite"]) {
        _timeSiztView.DateLable.text = _meetModel.meetDate;
        _timeSiztView.SiztTile_lable.text = _meetModel.meetAddrName;
        _timeSiztView.textttView.text  = _meetModel.meetAddr;
        [self showSizt_TimeApi];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打电话" message:_meetModel.teacherMobile delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
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
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_meetModel.teacherMobile]]];
    }
}

#pragma mark - 私信
- (void)BtnClcick:(UIButton *)sender
{
    if (sender.tag == 22222) {
        _cancelVC = [[CancelViewController alloc] init];
        _cancelVC.conventionId = self.mid;
        _cancelVC.meetStase = _meetModel.meetStatus;
        __weak __typeof__(self) weakSelf = self;
        [_cancelVC setRemovePushVCBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
        [self.navigationController pushViewController:_cancelVC animated:YES];
    }else{
        changeBtn.userInteractionEnabled = NO;
        //融云登录先屏蔽
        
//        [RongImUserLogin jumpRongCloudChatVCWithViewController:self TargetId:_meetModel.teacherId];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
