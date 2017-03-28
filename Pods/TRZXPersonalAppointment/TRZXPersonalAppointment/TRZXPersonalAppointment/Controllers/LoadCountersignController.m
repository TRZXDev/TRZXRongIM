//
//  LoadCountersignController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "LoadCountersignController.h"
#import "loadView.h"
#import "TRZXPJiDuView.h"
#import "CancelViewController.h"
#import "YuYueViewController.h"
#import "MeetModel.h"
#import "MyExpertViewController.h"
//#import "ConsultingDetailsViewController.h"
#import "TRZAExpertsDetailModel.h"

#import "TRZXPersonalAppointmentPch.h"


@interface LoadCountersignController ()


@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) UIImageView *icimage;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *moneyLable;
@property (strong, nonatomic)UILabel *timeLable;
@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) UILabel *quanxiaoLable;
@property (strong, nonatomic) MeetModel *meetModel;

@property (strong, nonatomic) TRZXPJiDuView *jinduView;
@property (strong, nonatomic) NSString *vipStr;

@end

@implementation LoadCountersignController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = backColor;
    [self requestFindInfo];
    
}

- (void)goBackView:(id)sender{

    if ([self.superType isEqualToString:@"meet1"]) {

        //哪里进来跳进哪里 先注销
        
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[ConsultingDetailsViewController class]]){
//                ConsultingDetailsViewController * csController = (ConsultingDetailsViewController*)vc;
//                 [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationTheme object:nil];
//                [self.navigationController popToViewController:csController animated:YES];
//                return;
//            }
//        }
    }else {
        [self.delegate push1ZhuangTai];
//        [self.navigationController popViewControllerAnimated:true];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[MyExpertViewController class]]){
                MyExpertViewController * csController = (MyExpertViewController*)vc;
                [self.navigationController popToViewController:csController animated:YES];
                return;
            }
            
        }
        
    }

    
}


#pragma mark - 查询约见信息

- (void)requestFindInfo
{

    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findInfo",
                             @"id":_conventionId?_conventionId:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        
        if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]) {
            _meetModel = [MeetModel mj_objectWithKeyValues:responseObj[@"data"]];
            _vipStr = responseObj[@"vip"];
            [self topView];
            [self cellView];
            if ([self.superType isEqualToString:@"meet"]||[self.superType isEqualToString:@"meet1"]) {
                [self createButton];
                self.title = _titleName?_titleName:@"待专家确认";
            } else if ([self.superType isEqualToString:@"loadRefund"]) {//取消
                [self quXiaoYY];
                self.title = _titleName;
            }else if ([self.superType isEqualToString:@"12"]) {
                self.title = _titleName;
            }else if ([self.superType isEqualToString:@"10"]) {//系统取消
                self.title = _titleName;
                [self quXiaoYY];
            }else if ([self.superType isEqualToString:@"loadRefundLGQ"]){//退款取消
                [self quXiaoYY];
                self.title = _titleName;
            }else {
                [self quXiaoYY];
                self.title = _titleName;
            }
            _dateLable.text = _meetModel.createDate;
            _numberLable.text = _meetModel.orderId;
            _nameLable.text = _meetModel.teacherName;
            if ([_vipStr isEqualToString:@"1"]) {
                _moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.vipPrice];
            }else{
                _moneyLable.text = [NSString stringWithFormat:@"%@元/次",_meetModel.muchOnce];
            }
            _timeLable.text =[NSString stringWithFormat:@"约%@",_meetModel.timeOnce];
            _textLable.text = _meetModel.topicTitle;
            if ([self.superType isEqualToString:@"10"]) {//系统取消
                _quanxiaoLable.text = @"学员超过24小时未付款，约见取消";
            }else{
                _quanxiaoLable.text = _meetModel.qxReason;
            }
            [_icimage sd_setImageWithURL:[NSURL URLWithString:_meetModel.teacherPhoto] placeholderImage:[UIImage imageNamed:@"展位图"]];
            
        }
        
    }];
}



- (void)topView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    
    topView.userInteractionEnabled = YES;
//    UITapGestureRecognizer * singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topViewClick:)];
//    [topView addGestureRecognizer:singleTap1];
    
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(65);
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
        make.top.equalTo(topView.mas_top).offset(0);
        make.left.equalTo(topView.mas_left).offset(5);
        make.height.equalTo(@(25));
        make.width.equalTo(@(30));
    }];
    
    _numberLable = [[UILabel alloc] init];
    _numberLable.font = [UIFont systemFontOfSize:10];
    _numberLable.text = @"123321748264678412";
    [topView addSubview:_numberLable];
    [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(0);
        make.left.equalTo(topView.mas_left).offset(35);
        make.height.equalTo(@(25));
        make.width.equalTo(@(150));
    }];
    
    _dateLable = [[UILabel alloc] init];
    _dateLable.text = @"2012.12.12";
    _dateLable.font = [UIFont systemFontOfSize:10];
    [topView  addSubview:_dateLable];
    
    [_dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(0);
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
        make.top.equalTo(topView.mas_top).offset(0);
        make.right.equalTo(_dateLable.mas_left);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
    }];
    
    
    if ([self.superType isEqualToString:@"meet"]||[self.superType isEqualToString:@"meet1"]) {
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
                lable.textColor = heizideColor;
            }
            
            [self.view addSubview:lable];
        }
    } else {
        _jinduView = [[TRZXPJiDuView alloc] initWithFrame:CGRectMake(0, 100, WIDTH(self.view), 12)];
        [_jinduView JiDuNow:0 with:5];
        [self.view addSubview:_jinduView];
        NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
        for (int i = 0; i<5; i++) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 113, 50, 20)];
            lable.text = dataArr[i];
            lable.font = [UIFont systemFontOfSize:10];
            
            lable.textColor = heizideColor;
    
            [self.view addSubview:lable];
        }

    }
}

- (void)xiugaiClick:(UITapGestureRecognizer *)sender
{
    //跳回去的先注销
    
//    ConsultingDetailsViewController *  oneToOneList = [[ConsultingDetailsViewController alloc]initWithNibName:nil bundle:nil];
//    oneToOneList.hidesBottomBarWhenPushed = YES;
//    oneToOneList.mid = _meetModel.mid;
//    [self.navigationController pushViewController:oneToOneList animated:true];
    
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
    _timeLable.text = @"约1.5小时";
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
    _textLable.text = @"我我我我我我我哦我我我";
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

- (void)quXiaoYY {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, WIDTH(self.view), 21)];
    labelTitle.text = @"取消原因:";
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor = heizideColor;
    labelTitle.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:labelTitle];
    
    _quanxiaoLable = [[UILabel alloc]init];
    _quanxiaoLable.numberOfLines = 10;
    _quanxiaoLable.font = [UIFont systemFontOfSize:15];
    _quanxiaoLable.lineBreakMode = NSLineBreakByWordWrapping;
    _quanxiaoLable.textColor = heizideColor;
//    _quanxiaoLable.frame = CGRectMake(15, 320, WIDTH(self.view)-30, [_quanxiaoLable sizeThatFits:CGSizeMake(WIDTH(self.view)-30, MAXFLOAT)].height);
    [self.view addSubview:_quanxiaoLable];
    [_quanxiaoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(310);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        //        make.height.equalTo(@(50));
    }];
}

- (void)createButton {
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeBtn.frame = CGRectMake(10, 285, WIDTH(self.view)/2.0-20, 40);
    [changeBtn setTitle:@"修改约见信息" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    changeBtn.layer.cornerRadius = 20;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.borderWidth = 1;
    changeBtn.layer.borderColor = [[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [changeBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.tag = 11111;
    [self.view addSubview:changeBtn];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(WIDTH(self.view)/2.0+10, 285, WIDTH(self.view)/2.0-20, 40);
    [_cancelBtn setTitle:@"取消约见" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _cancelBtn.layer.cornerRadius = 20;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = [[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [_cancelBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.tag = 22222;
    [self.view addSubview:_cancelBtn];
}


- (void)BtnClcick:(UIButton *)sender
{
    if (sender.tag == 22222) {
        _cancelVC = [[CancelViewController alloc] init];
        _cancelVC.conventionId = _conventionId;
        _cancelVC.meetStase = _meetModel.meetStatus;
        [self.navigationController pushViewController:_cancelVC animated:YES];
    }else if (sender.tag == 11111){// 修改约见信息

        YuYueViewController *oneToOneDetails = [[YuYueViewController alloc]initWithNibName:nil bundle:nil];
        oneToOneDetails.teacherId = _meetModel.teacherId;
        oneToOneDetails.topicId = _meetModel.topicId;
        oneToOneDetails.YuYueType = @"我的问题";
        oneToOneDetails.superType = _superType;
        oneToOneDetails.mentId = _meetModel.mid;
        oneToOneDetails.problem = _meetModel.problem;
        oneToOneDetails.myIntroduce = _meetModel.myIntroduce;




        Ostlist *ostlistModel = [[Ostlist alloc]init];
        ostlistModel.topicTitle = _meetModel.topicTitle;
        if ([_vipStr isEqualToString:@"1"]) {
            ostlistModel.muchOnce = _meetModel.vipPrice;
        }else{
            ostlistModel.muchOnce = _meetModel.muchOnce;
        }
        ostlistModel.timeOnce = _meetModel.timeOnce;
        oneToOneDetails.ostlistModel = ostlistModel;
        [self.navigationController pushViewController:oneToOneDetails animated:true];


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
