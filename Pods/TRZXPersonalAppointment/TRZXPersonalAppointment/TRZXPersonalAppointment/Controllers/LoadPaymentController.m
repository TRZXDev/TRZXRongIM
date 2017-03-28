//
//  LoadPaymentController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "LoadPaymentController.h"
#import "TRZXPJiDuView.h"
#import "PersonalCell.h"
#import "PaymentCell.h"
#import "PaymentTimeCell.h"
#import "ChooseTimeController.h"
#import "MeetModel.h"

#import "TRZXPersonalAppointmentPch.h"

@interface LoadPaymentController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UILabel *numberLable;
@property (strong, nonatomic) UILabel *dateLable;
@property (strong, nonatomic) TRZXPJiDuView *jinduView;
@property (strong, nonatomic) UITableView *MyTableView;

@property (weak, nonatomic)UIButton *oldButton;
@property (copy, nonatomic) NSString *Payment_Type;

@property (weak, nonatomic) UIButton *qianBaoBtn;
@property (weak, nonatomic) UIButton *weiXingBtn;
@property (weak, nonatomic) UIButton *yinLianBtn;
@property (strong, nonatomic) UILabel *MoneyLable;

@property (nonatomic,strong) NSString *tnMode;
@property (nonatomic,strong) NSString *orderNumber;
@property (strong, nonatomic) MeetModel *meetModel;

@property (nonatomic,copy)NSString *moneyStrr;
@property (nonatomic,copy)NSString *notSetStr;//有无钱包
@property (strong, nonatomic)NSString *serverStr;

@property (nonatomic,copy)NSString *minus;
@property (nonatomic,copy)NSString *hour;
@property (nonatomic,assign)NSInteger mincount;
@property (nonatomic,assign)NSInteger hourcount;
@property (nonatomic,assign)NSInteger secondsCountDown; //倒计时总时长
@property (nonatomic,strong)NSTimer *countDownTimer;



@property (copy, nonatomic) NSString *vipStr;

@end

@implementation LoadPaymentController{
    
    NSString *MinuteStr;
    NSString *HourStr;
    UIButton *FinishBtn;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _Payment_Type = @"";
    [self requestFindInfo];
//    if (_Payment_Type.length == 0) {
//        [self requestFindInfo];
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //测试环境  上线时，请改为“00”
    _tnMode = @"01";
    _mincount = 0;
    _hourcount = 0;
    // Do any additional setup after loading the view.
    self.title = @"请学员付款";
    [self topView];
    [self tableViewUI];
    [self SubmitView];
    self.view.backgroundColor = backColor;

    //    当微信支付成功之后 进入成功的页面（先屏蔽）
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PayWechatSuccessMethod) name:PayWechatSuccess object:nil];
}

-(void)PayWechatSuccessMethod{

//    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ChooseTimeController *chooseTime = [[ChooseTimeController alloc] init];
        chooseTime.meetId = _conventionId;
        [self.navigationController pushViewController:chooseTime animated:YES];
    });

}

-(void)dealloc{
    //支付的先屏蔽
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:PayWechatSuccess object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    FinishBtn.userInteractionEnabled = YES;
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
            _moneyStrr = responseObj[@"amount"];
            _notSetStr = responseObj[@"notSet"];
            _serverStr = responseObj[@"serverDate"];
            NSString *timeServerStr = responseObj[@"serverDate"];
            _vipStr = responseObj[@"vip"];
            NSString *timeCreateStr = _meetModel.lastDateTime;
            
            long timeServer = timeServerStr.longLongValue;
            long timeCreate = timeCreateStr.longLongValue;
            long times = 24 * 3600 * 1000 - (timeServer - timeCreate);
            int time1 = (int)(times / (3600*1000));//小时
            int time2 = (int)((times - time1 * 3600 * 1000)/(60 * 1000));//分钟
            
            HourStr = [NSString stringWithFormat:@"%d",time1];
            MinuteStr = [NSString stringWithFormat:@"%d",time2];
            
            _secondsCountDown = times;
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            
            _numberLable.text = _meetModel.orderId;
            _dateLable.text =_meetModel.createDate;
            
            if ([responseObj[@"vip"] isEqualToString:@"1"]) {
                _MoneyLable.text = [NSString stringWithFormat:@"%@",_meetModel.vipPrice];
            }else{
                _MoneyLable.text = [NSString stringWithFormat:@"%@",_meetModel.muchOnce];
            }
            
            [_MyTableView reloadData];
            
        }
        
    }];
   
}

-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown--;
    //修改倒计时标签现实内容
    _mincount ++;
    
    PaymentTimeCell *cell = [self returnCell];
    
    if (_mincount == 59) {
        _mincount = 0;
        _hourcount ++;
        NSInteger min = [cell.MinuteLable.text integerValue];
        cell.MinuteLable.text = [NSString stringWithFormat:@"%ld",(long)--min];
    }
    if (_hourcount == 59) {
        _hourcount = 0;
        NSInteger hour = [cell.HourLable.text integerValue];
        cell.HourLable.text = [NSString stringWithFormat:@"%ld",(long)--hour];
    }

    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
    }
}


- (PaymentTimeCell *)returnCell
{
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
    PaymentTimeCell *cell = [self.MyTableView cellForRowAtIndexPath:indexpath];
    return cell;
}
- (void)goBackView:(id)sender
{
    [self.delegate push1ZhuangTai];
    [self.navigationController popViewControllerAnimated:YES];
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
        [_jinduView JiDuNow:3 with:5];
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
            
            [self.view addSubview:lable];
        }
}

- (void)SubmitView {
    UIView *submitView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGTH(self.view)-45, WIDTH(self.view)/3.0*2.0, 45)];
    submitView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:submitView];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(submitView)/2.0-60, 16, 32, 15)];
    lable.text = @"合计:";
    lable.font = [UIFont systemFontOfSize:13];
    [submitView addSubview:lable];
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(POINTX(lable)+30, 15, 15, 17)];
    lable1.text = @"￥";
    lable1.textColor = TRZXMainColor;
    lable1.font = [UIFont systemFontOfSize:15];
    [submitView addSubview:lable1];
    _MoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(POINTX(lable)+60, 14, 90, 17)];
    _MoneyLable.text = @"￥300";
    _MoneyLable.textAlignment = NSTextAlignmentLeft;
    _MoneyLable.font = [UIFont systemFontOfSize:20];
    _MoneyLable.textColor = TRZXMainColor;
    [submitView addSubview:_MoneyLable];
    
    FinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    FinishBtn.frame = CGRectMake(WIDTH(self.view)/3.0*2.0, HEIGTH(self.view)-45, WIDTH(self.view)/3.0, 45);
    FinishBtn.backgroundColor = TRZXMainColor;
    [FinishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [FinishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [FinishBtn addTarget:self action:@selector(FinishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:FinishBtn];
    
}

- (void)FinishBtn:(UIButton *)sender
{

   sender.userInteractionEnabled = NO;

    if (_Payment_Type.length == 0) {
//        [LCProgressHUD showInfoMsg:@"请选择付款方式"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择付款方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1002;
        [alert show];
        sender.userInteractionEnabled = YES;
    } else {

        //付款方式先注销了
        
//       [MobClick event:yueJianEvent attributes:@{@"mid":_conventionId?_conventionId:@"",@"money":_meetModel.muchOnce?_meetModel.muchOnce:@"",@"user_id":[KPOUserDefaults userId]?[KPOUserDefaults userId]:@""}];
//        if ([_Payment_Type isEqualToString:@"Purse"]) {
//            sender.userInteractionEnabled = YES;
//            ZhiFuMiMaController *zhifuMM = [[ZhiFuMiMaController alloc] init];
//            if ([_vipStr isEqualToString:@"1"]) {
//                zhifuMM.money = _meetModel.vipPrice;
//            }else{
//                zhifuMM.money = _meetModel.muchOnce;
//            }
//            zhifuMM.icmImage = _meetModel.stuPhoto;
//            zhifuMM.mid = _conventionId;
//            zhifuMM.typeStr = @"zhifu";
//            [self.navigationController pushViewController:zhifuMM animated:YES];
//        }
//        if ([_Payment_Type isEqualToString:@"UnionPay"]) {
////            sender.userInteractionEnabled = YES;
//            [payTool pay_ZF_WithViewController:self PaifId:_conventionId andAction:ActionTypeMeet andPayMoney:_meetModel.muchOnce andPayMethod:payMethodUnion];
//        }
//        if ([_Payment_Type isEqualToString:@"WeiXin"]) {
//            sender.userInteractionEnabled = YES;
//            [payTool pay_ZF_WithViewController:self PaifId:_conventionId andAction:ActionTypeMeet andPayMoney:_meetModel.muchOnce andPayMethod:payMethodWechat];
        
//        }
    }
}



#pragma mark - 请求订单流水号

- (void)requestOrderNumber
{

    NSDictionary *params = @{
                             @"requestType":@"AppPay_Api",
                             @"apiType":@"unionpay",
                             @"meetId":_conventionId?_conventionId:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        
           if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]){
            _orderNumber = [responseObj objectForKey:@"tn"];
            if (_orderNumber.length>0) {
               [self startUPPayPlugin:[responseObj objectForKey:@"tn"]];
            }
        }

    }];
    
}




#pragma mark 开始银联支付

-(void)startUPPayPlugin:(NSString*)orderNumber{
//支付先屏蔽
    
//    [[UPPaymentControl defaultControl] startPay:orderNumber fromScheme:@"UPPayDemo" mode:self.tnMode viewController:self];

}

#pragma mark UPPayPluginResult
- (void)UPPayPluginResult:(NSString *)result
{

    if ([result isEqualToString:@"cancel"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=1001;
        [alert show];
    }
    else if([result containsString:@"success"]){

        _chooseTimeVC = [[ChooseTimeController alloc] init];
        _chooseTimeVC.meetId = self.conventionId;
        [self.navigationController pushViewController:_chooseTimeVC animated:YES];




    }
}




#pragma mark - 通知后台

- (void)requestUniuonPayNotice:(NSString*)respCode orderNumber:(NSString*)orderNumber
{
    NSDictionary *params = @{
                             @"requestType":@"AppPay_Api",
                             @"apiType":@"uniuonPayNotice",
                             @"respCode":respCode?respCode:@"",
                              @"tn":orderNumber?orderNumber:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
    
        if ([[responseObj objectForKey:@"status_code"] isEqualToString:@"200"]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"支付成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
    }];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag==1000){
        _chooseTimeVC = [[ChooseTimeController alloc] init];
        _chooseTimeVC.meetId = self.conventionId;
        [self.navigationController pushViewController:_chooseTimeVC animated:YES];

    }
//跳转充值钱包的先屏蔽
    
    if ((alertView.tag == 2017031403)&&(buttonIndex == 1)) {
        //        EOWalletViewController *wallet = [[EOWalletViewController alloc]init];
        //        wallet.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:wallet animated:YES];
    }


}



- (void)tableViewUI {
    _MyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, WIDTH(self.view), HEIGTH(self.view)-140-50)];
    _MyTableView.delegate = self;
    _MyTableView.dataSource = self;
    _MyTableView.backgroundColor = backColor;
    _MyTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_MyTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 115;
    } else if (indexPath.row == 1) {
        return 204;
    } else {
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *PersonalID = @"PersonalID";
        PersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalCell" owner:self options:nil] lastObject];
        }
        cell.vipStr = _vipStr;
        cell.model = _meetModel;
//        cell.dateLable.text =[NSString stringWithFormat:@"约%@",_meetModel.createDate];
        cell.cellBackView.backgroundColor = moneyColor;
        cell.contentView.backgroundColor = backColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *PersonalID = @"PaymentID";
        PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PaymentCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PaymentCell_Tap:)];
        [cell.PurseView addGestureRecognizer:tap];
        [cell.WeiXinView addGestureRecognizer:tap1];
        [cell.UnionPayView addGestureRecognizer:tap2];
        [cell.Purse addGestureRecognizer:tap3];
        [cell.WeiXin addGestureRecognizer:tap4];
        [cell.UnionPay addGestureRecognizer:tap5];
        cell.Purse.tag = purseTag;
        cell.PurseView.tag = purseTag;
        cell.WeiXinView.tag = weiXinTag;
        cell.WeiXin.tag = weiXinTag;
        cell.UnionPayView.tag = unionpayTag;
        cell.UnionPay.tag = unionpayTag;
        _qianBaoBtn = cell.Purse;
        _weiXingBtn = cell.WeiXin;
        _yinLianBtn = cell.UnionPay;
        _qianBaoBtn.tag = purseTag;
        _weiXingBtn.tag = weiXinTag;
        _yinLianBtn.tag = unionpayTag;
        cell.BalanceLabel.text = [NSString stringWithFormat:@"(账号余额:%@元)",_moneyStrr?_moneyStrr:@"0"];
        [_qianBaoBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_weiXingBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_yinLianBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.backgroundColor = backColor;
        return cell;
    } else {
        static NSString *PersonalID = @"PaymentTimeID";
        PaymentTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonalID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PaymentTimeCell" owner:self options:nil] lastObject];
        }
        cell.HintView.backgroundColor = moneyColor;
        cell.HourLable.text = HourStr?HourStr:@"23";
        cell.MinuteLable.text = MinuteStr?MinuteStr:@"59";
        cell.NonsenseLable.textColor = moneyColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = backColor;
        return cell;
    }
}

- (void)PaymentCell_Tap:(UITapGestureRecognizer *)tap {
    UIView *tapView = tap.view;
    if (tapView.tag == purseTag) {
        if (_notSetStr) {


            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还未开通钱包支付，暂时不能使用，请前往钱包开通" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"开通", nil];
            alertView.tag = 2017031403;
            [alertView show];
        }else{
            if ((_moneyStrr.doubleValue == 0)||(_moneyStrr.doubleValue<_meetModel.muchOnce.doubleValue&&![_vipStr isEqualToString:@"1"])||(_moneyStrr.doubleValue<_meetModel.vipPrice.doubleValue&&[_vipStr isEqualToString:@"1"])) {


                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包余额不足，请前往钱包充值" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alertView.tag = 2017031403;
                [alertView show];
            }else{
                _oldButton .selected = NO;
                _qianBaoBtn.selected = YES;
                _oldButton = _qianBaoBtn;
                _Payment_Type = @"Purse";
            }
        }
    }
    if (tapView.tag == weiXinTag) {
        _oldButton .selected = NO;
        _weiXingBtn.selected = YES;
        _oldButton = _weiXingBtn;
        _Payment_Type = @"WeiXin";
    }
    if (tapView.tag == unionpayTag) {
        _oldButton .selected = NO;
        _yinLianBtn.selected = YES;
        _oldButton = _yinLianBtn;
        _Payment_Type = @"UnionPay";
    }

}

- (void)BtnClick:(UIButton *)sender
{
    
    if (sender.tag == purseTag) {
        if (_notSetStr) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还未开通钱包支付，暂时不能使用钱包" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            if ((_moneyStrr.doubleValue == 0)||(_moneyStrr.doubleValue<_meetModel.muchOnce.doubleValue&&![_vipStr isEqualToString:@"1"])||(_moneyStrr.doubleValue<_meetModel.vipPrice.doubleValue&&[_vipStr isEqualToString:@"1"])) {


                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包余额不足，请前往钱包充值" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alertView.tag = 2017031403;
                [alertView show];
                
            }else if ((_moneyStrr.doubleValue == 0)||(_moneyStrr.doubleValue<_meetModel.muchOnce.doubleValue&&![_vipStr isEqualToString:@"1"])||(_moneyStrr.doubleValue<_meetModel.vipPrice.doubleValue&&[_vipStr isEqualToString:@"1"])) {


                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"钱包余额不足，请前往钱包充值" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                alertView.tag = 2017031403;
                [alertView show];

            }else{
                _oldButton .selected = NO;
                sender.selected = YES;
                _oldButton = sender;
                _Payment_Type = @"Purse";
            }
        }
    }
    if (sender.tag == weiXinTag) {
        _oldButton .selected = NO;
        sender.selected = YES;
        _oldButton = sender;
        _Payment_Type = @"WeiXin";
    }
    if (sender.tag == unionpayTag) {
        _oldButton .selected = NO;
        sender.selected = YES;
        _oldButton = sender;
        _Payment_Type = @"UnionPay";
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
