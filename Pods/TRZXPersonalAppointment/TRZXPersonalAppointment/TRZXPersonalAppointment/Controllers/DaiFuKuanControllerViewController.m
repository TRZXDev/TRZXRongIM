//
//  DaiFuKuanControllerViewController.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/25.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "DaiFuKuanControllerViewController.h"
#import "TRZXPJiDuView.h"
#import "ChonghuayjnCell.h"
#import "SrudensDetailed.h"
#import "QuXiaoTableViewCell.h"
#import "conSultView.h"
#import "TimeSiztView.h"
#import "EvaluateBelowCell.h"

#import "TRZXPersonalAppointmentPch.h"


@interface DaiFuKuanControllerViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DaifuKuanDelegate,CellButtonDelegate>

{
    NSString *_str1;
    NSString *_str2;
}

@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) TRZXPJiDuView *jinduView;
@property (strong, nonatomic) UITableView *MyTableView;
@property (strong, nonatomic) SrudensDetailed *mode;


@property (strong, nonatomic) ConsultView *conSultView;
@property (strong, nonatomic) TimeSiztView *timeSiztView;
@property (strong, nonatomic) NSString *vipStr;

@end

@implementation DaiFuKuanControllerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backColor;
    if ([self.vCType isEqualToString:@"DXYXZSJ"]) {
        self.title = @"待学员选择约见时间";
    }else if ([self.vCType isEqualToString:@"DXYFK"]) {
        self.title = @"待学员付款";
    } else if ([self.vCType isEqualToString:@"QX"]){
        self.title = @"已取消";
    }else if ([self.vCType isEqualToString:@"XTQX"]){
        self.title = @"已取消";
    }else if ([self.vCType isEqualToString:@"DTK"]){
        self.title = @"已取消,待退款";
    }else if ([self.vCType isEqualToString:@"YTK"]){
        self.title = @"已取消,已退款";
    }else if ([self.vCType isEqualToString:@"WTG"]){
        self.title = @"约见未通过";
    } else if ([self.vCType isEqualToString:@"DSFJM"]) {
        self.title = @"待双方见面";
    } else if ([self.vCType isEqualToString:@"DPJ"]) {
        self.title = @"待评价";
    }

    
    
    [self request_Detailed];
}
- (void)jiazaiTableView
{
    _MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 135, WIDTH(self.view), 204)];
    
    if ([self.vCType isEqualToString:@"DSFJM"]) {
        _MyTableView.frame = CGRectMake(0, 135,  WIDTH(self.view), 204);
        
    }
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    _MyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _MyTableView.scrollEnabled = NO;
    _MyTableView.showsHorizontalScrollIndicator = NO;
    _MyTableView.showsVerticalScrollIndicator = NO;
    _MyTableView.backgroundColor = backColor;
    [self.view addSubview:_MyTableView];
}

- (void)goBackView:(id)sender
{
    [self.delegate changeTopVC];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)quXiaoYY {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 345, WIDTH(self.view), 21)];
    labelTitle.text = @"取消原因:";
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.textColor = heizideColor;
    labelTitle.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:labelTitle];
    
    UILabel *lableText = [[UILabel alloc] initWithFrame:CGRectMake(8, 375, WIDTH(self.view)-16, 21)];
    lableText.numberOfLines = 0;
    lableText.font = [UIFont systemFontOfSize:13];
    lableText.lineBreakMode = NSLineBreakByWordWrapping;
    lableText.textColor = heizideColor;
    if ([self.vCType isEqualToString:@"XTQX"]) {//系统取消
        lableText.text = @"学员超过24小时未付款，约见取消";
    }else{
    lableText.text = _mode.data.qxReason;
    }
    lableText.frame = CGRectMake(10, 375, WIDTH(self.view)-16, [lableText sizeThatFits:CGSizeMake(WIDTH(self.view)-16, MAXFLOAT)].height);
    [self.view addSubview:lableText];
}

- (void)buttonView {
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    changeBtn.frame = CGRectMake(10, 345, WIDTH(self.view)/2.0-20, 40);
    [changeBtn setTitle:@"私聊" forState:UIControlStateNormal];
    [changeBtn setTitleColor:grayKColor forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 20;
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.borderWidth = 1;
    changeBtn.layer.borderColor = [grayKColor CGColor];
    [changeBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    changeBtn.tag = 11111;
    [self.view addSubview:changeBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(WIDTH(self.view)/2.0+10, 345, WIDTH(self.view)/2.0-20, 40);
    [cancelBtn setTitle:@"确认见过" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = TRZXMainColor;
    cancelBtn.layer.cornerRadius = 20;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1] CGColor];
    [cancelBtn addTarget:self action:@selector(BtnClcick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 22222;
    [self.view addSubview:cancelBtn];
    
    if ([self.vCType isEqualToString:@"DSFJM"]) {
        [self createBottomView];
    }
    
}

- (void)BtnClcick:(UIButton *)sender {
    
    if (sender.tag == 11111) {
        //融云的先屏蔽
        
//        [RongImUserLogin jumpRongCloudChatVCWithViewController:self TargetId:_mode.data.studentId];
        
    }
    if (sender.tag == 22222) {
        _str1 = @"已经和学员见过了?";
        _str2 = [@"确认见过后学员即可评价" stringByAppendingFormat:@"\n专家一周内收到付款"];
        [self alertViewStr];

    }
    
    
}

- (void)alertViewStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_str1 message:_str2 delegate:self cancelButtonTitle:@"还没有" otherButtonTitles:@"见过了", nil];
    alert.tag = 122113131;
//    alert.tag = 600;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 122113131) {
        if (buttonIndex == 0) {
            
        } else {
            [self request_QueRenJian];
        }
    }else
    {
        if (buttonIndex == 0) {
//            TRZXLog(@"取消按钮被点击");
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mode.data.stuMobile]]];
        }
    }
 
}


- (void)request_QueRenJian {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"updateStatus",
                             @"id":self.mid?self.mid:@"",
                             @"meetStatus":@"7"
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            [self.delegate changeTopVC];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (void)request_Detailed {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"findInfo",
                             @"id":self.mid?self.mid:@""
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        
        _vipStr = responseObj[@"vip"];
        _mode = [SrudensDetailed mj_objectWithKeyValues:responseObj];
        if ([self.vCType isEqualToString:@"QX"]){
            //            self.title = @"已取消"];
            [self quXiaoYY];
        }else if ([self.vCType isEqualToString:@"XTQX"]){
            //            self.title = @"已取消"];
            [self quXiaoYY];
        }else if ([self.vCType isEqualToString:@"DTK"]){
            //            self.title = @"已取消,待退款"];
            [self quXiaoYY];
        }else if ([self.vCType isEqualToString:@"YTK"]){
            //            self.title = @"已取消,已退款"];
            [self quXiaoYY];
        }else if ([self.vCType isEqualToString:@"WTG"]){
            //            self.title = @"约见未通过"];
        } else if ([self.vCType isEqualToString:@"DSFJM"]) {
            //            self.title = @"待双方见面"];
            [self buttonView];
        } else if ([self.vCType isEqualToString:@"DPJ"]) {
            //            self.title = @"待评价"];
        }
        [self topView];
        [self jiazaiTableView];
        [_MyTableView reloadData];
        
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
    if ([self.vCType isEqualToString:@"DXYXZSJ"]) {
        [_jinduView JiDuNow:3 with:5];
    }else if ([self.vCType isEqualToString:@"DXYFK"]) {
        [_jinduView JiDuNow:3 with:5];
    }else if ([self.vCType isEqualToString:@"QX"]) {
        [_jinduView JiDuNow:0 with:5];
    }else if ([self.vCType isEqualToString:@"XTQX"]) {
        [_jinduView JiDuNow:0 with:5];
    }else if ([self.vCType isEqualToString:@"WTG"]) {
        [_jinduView JiDuNow:0 with:5];
    }else if ([self.vCType isEqualToString:@"DTK"]) {
        [_jinduView JiDuNow:0 with:5];
    }else if ([self.vCType isEqualToString:@"YTK"]) {
        [_jinduView JiDuNow:0 with:5];
    }else if ([self.vCType isEqualToString:@"DSFJM"]){
        [_jinduView JiDuNow:4 with:5];
    }else if ([self.vCType isEqualToString:@"DPJ"]){
        [_jinduView JiDuNow:5 with:5];
    }
    
    [self.view addSubview:_jinduView];
    NSArray *dataArr = @[@"学员预约",@"专家确认",@"学员付款",@"确认见过",@"学员评价"];
    for (int i = 0; i<5; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(WIDTH(self.view)/6)-25, 113, 50, 20)];
        lable.text = dataArr[i];
        lable.font = [UIFont systemFontOfSize:10];
        if (i == 2) {
            lable.textColor = TRZXMainColor;
        } else {
            lable.textColor = heizideColor;
        }
        if ([self.vCType isEqualToString:@"DXYFK"]||[self.vCType isEqualToString:@"DXYXZSJ"]) {
            if (i == 2) {
                lable.textColor = TRZXMainColor;
            } else {
                lable.textColor = heizideColor;
            }

        } else if ([self.vCType isEqualToString:@"QX"]) {
            lable.textColor = heizideColor;
        }else if ([self.vCType isEqualToString:@"XTQX"]) {
            lable.textColor = heizideColor;
        }else if ([self.vCType isEqualToString:@"DTK"]) {
            lable.textColor = heizideColor;
        }else if ([self.vCType isEqualToString:@"YTK"]) {
            lable.textColor = heizideColor;
        }else if ([self.vCType isEqualToString:@"WTG"])
        {
            lable.textColor = heizideColor;
        }else if ([self.vCType isEqualToString:@"DSFJM"]){
            if (i == 3) {
                lable.textColor = TRZXMainColor;
            } else {
                lable.textColor = heizideColor;
            }

        }else if ([self.vCType isEqualToString:@"DPJ"]){
            if (i == 4) {
                lable.textColor = TRZXMainColor;
            } else {
                lable.textColor = heizideColor;
            }
            
        }

        
        [self.view addSubview:lable];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if ([self.vCType isEqualToString:@"DTK"]||[self.vCType isEqualToString:@"YTK"]){
//        return 2;
//    }else{
//        return 1;
//    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 204;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

//    static NSString *personalID = @"personalID";
    ChonghuayjnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChonghuayjnCell"];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChonghuayjnCell" owner:self options:nil] lastObject];
    }
        cell.iconImage.layer.cornerRadius = 6.0;
        cell.iconImage.layer.masksToBounds = YES;
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:_mode.data.stuPhoto] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        cell.nameLable.text = _mode.data.stuName;
        if ([_vipStr isEqualToString:@"1"]&&[_vipPDStr isEqualToString:@"1"]) {
            cell.moneyLable.text = [NSString stringWithFormat:@"%@元/次",_mode.data.vipPrice];
        }else{
            cell.moneyLable.text = [NSString stringWithFormat:@"%@元/次",_mode.data.muchOnce];
        }
        cell.dateLable.text = [NSString stringWithFormat:@"约%@",_mode.data.timeOnce];
        cell.textLable.text = _mode.data.topicTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
    
        return cell;
    }else{
//        static NSString *personalID = @"personal1ID";
        QuXiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuXiaoTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"QuXiaoTableViewCell" owner:self options:nil] lastObject];
        }
        cell.yuanyinLabel.text = _mode.data.qxReason;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        return cell;
    }
}



- (void)createBottomView
{
    EvaluateBelowCell *cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"EvaluateBelowCell" owner:self options:nil] firstObject];
    cell.CellTitleLable.text = @"约见信息";
    cell.jieShaoLable.text = @"学员介绍";
    cell.phoneLable.text = @"学员电话";
    
    cell.frame = CGRectMake(10, 345 +40 +10, WIDTH(self.view)-20, 165);
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
        _conSultView.texttView.text = _mode.data.problem;
        _conSultView.TitleLable.text = @"请教的问题";
        [self showConsultView];
        
    } else if ([str isEqualToString:@"Myintroduce"]) {
        _conSultView.TitleLable.text = @"学员介绍";
        _conSultView.texttView.text = _mode.data.myIntroduce;
        [self showConsultView];
        
    } else if ([str isEqualToString:@"TimeSite"]) {
        _timeSiztView.DateLable.text = _mode.data.meetDate;
        _timeSiztView.SiztTile_lable.text = _mode.data.meetAddrName;
        _timeSiztView.textttView.text  = _mode.data.meetAddr;
        [self showSizt_TimeApi];
    
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打电话" message: _mode.data.stuMobile delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        [alert show];
    }
    
}


- (void)showConsultView {
    [self.view bringSubviewToFront:_conSultView];
    _conSultView.hidden = NO;
}

- (void)showSizt_TimeApi {
    [self.view bringSubviewToFront:_timeSiztView];
    _timeSiztView.hidden = NO;
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
