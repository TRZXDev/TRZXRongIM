//
//  CreateTimeController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/22.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "CreateTimeController.h"
#import "PikerTimeCell.h"
#import "ChoosetimeCell.h"
#import "WriteDataCell.h"
#import "MyStudensController.h"
#import "MyExpertModel.h"


#import "TRZXPersonalAppointmentPch.h"


#define HOURARRAYUSFou @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23"]

@interface CreateTimeController () <UIPickerViewDataSource,UIPickerViewDelegate,addDDDelegate,writeToDelegate,UITextFieldDelegate,UITextViewDelegate,deleteCellDelegate,UIAlertViewDelegate>

@property (strong, nonatomic)UIView *addTimeAndDD;

@property (strong, nonatomic)UIScrollView *myScrollView;

@property (strong, nonatomic)NSArray *dataArr;

@property (assign, nonatomic)BOOL isOver;

@property (assign, nonatomic)BOOL isTime;

@property (assign, nonatomic)int addCount;

@property (strong, nonatomic)PikerTimeCell *piker1;
@property (strong, nonatomic)PikerTimeCell *piker2;
@property (strong, nonatomic)PikerTimeCell *piker3;
@property (strong, nonatomic)NSString *alertStr1;

@property (strong, nonatomic)ChoosetimeCell *Choosetime1;
@property (strong, nonatomic)ChoosetimeCell *Choosetime2;
@property (strong, nonatomic)ChoosetimeCell *Choosetime3;

@property (strong, nonatomic)WriteDataCell *writeData;

@property (strong, nonatomic)NSMutableArray *deleDataArr;

@property (strong, nonatomic) NSString *dayStr;
@property (strong, nonatomic) NSString *hourStr;
@property (strong, nonatomic) NSString *minutesStr;

@property (strong,nonatomic) NSString *dateStr;
@property (strong,nonatomic) NSString *jianMianTitle;
@property (strong, nonatomic) NSString *PhoneAndDiZhi;

@property (strong, nonatomic) NSString *querendeStr;


@property (strong, nonatomic) NSString * didianStr;

@property (nonatomic, strong) NSArray *showDayArray;
@property (nonatomic, strong) NSArray *hourArray;
@property (nonatomic, strong) NSArray *minuteArray;
@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSMutableArray *DayArr;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic,strong)UIPickerView *pickView;

@end

@implementation CreateTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.minutes = [[NSMutableArray alloc]init];
    
    for (int i=0; i<60; i++) {
        if (i < 10) {
           [self.minutes addObject:[NSString stringWithFormat:@"0%d",i]];
        }else
        {
           [self.minutes addObject:[NSString stringWithFormat:@"%d",i]];
        }
     
    }
    _hourArray = [self validHourArray];
    _minuteArray = [self validMinuteArray];
    
    _deleDataArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSArray alloc] init];
    _addCount = 0;
    
    
    [self date_Api];
    self.title = @"选择约见时段";
    [self addBtn];
    [self CellAddTime];
    [self tableView_UI];
    [self createCell];
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"您已接收与学员约见,请选择约见";
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.textColor = heizideColor;
    [self.view addSubview:lable1];
    
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(70);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    UILabel *lable2 = [[UILabel alloc] init];
    lable2.text = @"时间与地点";
    lable2.font = [UIFont systemFontOfSize:14];
    lable2.textAlignment = NSTextAlignmentCenter;
    lable2.textColor = heizideColor;
    [self.view addSubview:lable2];
    
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(87);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    
    UILabel *lable3 = [[UILabel alloc] init];
    lable3.text = @"提供1-3个约见的时间与地点供学员在付款后选择";
    lable3.font = [UIFont systemFontOfSize:12];
    lable3.textAlignment = NSTextAlignmentCenter;
    lable3.textColor = zideColor;
    [self.view addSubview:lable3];
    
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(115);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(300));
        make.height.equalTo(@(20));
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(0, HEIGTH(self.view)-48, WIDTH(self.view), 48);
    [_button setTitle:@"完成" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:17];
    _button.backgroundColor = TRZXMainColor;
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}
- (void)addBtn{
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
}
- (void)date_Api {
    NSDictionary *params = @{
                             @"requestType":@"GetDate_Tool"
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
           _dataArr = [MyExpertModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i=0; i<_dataArr.count; i++) {
            MyExpertModel *mode = [_dataArr objectAtIndex:i];
            NSString *str1 = [mode.date substringWithRange:NSMakeRange(5, 2)];
            NSString *str2 = [mode.date substringWithRange:NSMakeRange(8, 2)];
            _dayStr = [NSString stringWithFormat:@"%@月%@日 %@",str1,str2,mode.week];
            [tempComments addObject:_dayStr];
        }
        _showDayArray = [tempComments copy];
        [_piker1.pikerTime reloadComponent:0];
        [_piker2.pikerTime reloadComponent:0];
        [_piker3.pikerTime reloadComponent:0];

    }
     ];
    
}

- (void)CellAddTime {
    _addTimeAndDD = [[UIView alloc] initWithFrame:CGRectMake(8, 145, WIDTH(self.view)-16, 80)];
    _addTimeAndDD.userInteractionEnabled = YES;
    _addTimeAndDD.backgroundColor = [UIColor whiteColor];
    _addTimeAndDD.layer.cornerRadius = 10;
    _addTimeAndDD.layer.masksToBounds = YES;
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(self.view)/2.0-100, 30, 20, 20)];
    addImage.image = [UIImage imageNamed:@"jia"];
    addImage.userInteractionEnabled = YES;
    [_addTimeAndDD addSubview:addImage];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)/2.0-70, 30, 140, 20)];
    lable4.text = @"添加约见时间与地点";
    lable4.font = [UIFont systemFontOfSize:15];
    lable4.textAlignment = NSTextAlignmentCenter;
    lable4.textColor = heizideColor;
    [_addTimeAndDD addSubview:lable4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAdd:)];
    [_addTimeAndDD addGestureRecognizer:tap];
    [self.view addSubview:_addTimeAndDD];
    
}

- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView_UI {
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, WIDTH(self.view), HEIGTH(self.view)-180)];
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.hidden = YES;
    _myScrollView.contentSize = CGSizeMake(0, 650);
    [self.view addSubview:_myScrollView];
}

- (void)createCell {
    _piker1 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PikerTimeCell" owner:self options:nil] lastObject];
    _piker1.frame = CGRectMake(0, 0, WIDTH(self.view), 250);
    _piker1.hidden = YES;
    _piker1.delegate = self;
    _piker1.pikerTime.delegate = self;
    _piker1.pikerTime.dataSource = self;
    
    _Choosetime1 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChoosetimeCell" owner:self options:nil] lastObject];
    _Choosetime1.CellBackView.backgroundColor = moneyColor;
    _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
    _Choosetime1.hidden = YES;
    _Choosetime1.guanBiBtn.hidden = NO;
    _Choosetime1.delegate = self;
    
    _piker2 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PikerTimeCell" owner:self options:nil] lastObject];
    _piker2.frame = CGRectMake(0, 180, WIDTH(self.view), 250);
    _piker2.hidden = YES;
    _piker2.delegate = self;
    _piker2.pikerTime.delegate = self;
    _piker2.pikerTime.dataSource = self;
    _Choosetime2 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChoosetimeCell" owner:self options:nil] lastObject];
    _Choosetime2.CellBackView.backgroundColor = moneyColor;
    _Choosetime2.frame = CGRectMake(0, 170, WIDTH(self.view), 150);
    _Choosetime2.hidden = YES;
    _Choosetime2.guanBiBtn.hidden = NO;
    _Choosetime2.delegate = self;
    _piker3 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PikerTimeCell" owner:self options:nil] lastObject];
    _piker3.frame = CGRectMake(0, 345, WIDTH(self.view), 250);
    _piker3.hidden = YES;
    _piker3.delegate = self;
    _piker3.pikerTime.delegate = self;
    _piker3.pikerTime.dataSource = self;
    _Choosetime3 = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ChoosetimeCell" owner:self options:nil] lastObject];
    _Choosetime3.delegate = self;
    _Choosetime3.CellBackView.backgroundColor = moneyColor;
    _Choosetime3.frame = CGRectMake(0, 330, WIDTH(self.view), 150);
    _Choosetime3.hidden = YES;
    _Choosetime3.guanBiBtn.hidden = NO;
    _Choosetime1.backgroundColor = backColor;
    _Choosetime2.backgroundColor = backColor;
    _Choosetime3.backgroundColor = backColor;
    _piker1.backgroundColor = backColor;
    _piker2.backgroundColor = backColor;
    _piker3.backgroundColor = backColor;
    [_myScrollView addSubview:_piker1];
    [_myScrollView addSubview:_piker2];
    [_myScrollView addSubview:_piker3];
    [_myScrollView addSubview:_Choosetime1];
    [_myScrollView addSubview:_Choosetime2];
    [_myScrollView addSubview:_Choosetime3];
    
    _writeData = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WriteDataCell" owner:self options:nil] lastObject];
    _writeData.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    _writeData.contentView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    _writeData.dataText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _writeData.quxiaoBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _writeData.frame = self.view.frame;
    _writeData.delegate = self;
    _writeData.DiDianText.delegate = self;
    _writeData.dataText.delegate = self;
    _writeData.hidden = YES;
    [self.view addSubview:_writeData];
}


- (void)tapAdd:(UITapGestureRecognizer *)tap {
    
    _myScrollView.hidden = NO;
    _addTimeAndDD.hidden = YES;
    if (_addCount == 0) {
        _addCount +=1;
        _piker1.hidden = NO;
        self.rightButton.enabled = NO;
    }
    
}


- (void)saveBtnClick:(UIButton *)sender
{
    if (_addCount == 0) {
        self.rightButton.enabled = NO;
        _piker1.hidden = NO;
    }
    if (_addCount == 1) {
        _piker2.hidden = NO;
        self.rightButton.enabled = NO;
    }
    if (_addCount == 2) {
        
        _piker3.hidden = NO;
        self.rightButton.enabled = NO;
    }
    if (_addCount >2) {
        _alertStr1 = @"最多添加三个约见时段";
        [self alertView1Str];
        return;
    }
    _addCount +=1;
    
}

- (void)addDD
{
    _writeData.hidden = NO;
    _writeData.DiDianText.text = @"";
    _writeData.dataText.text = @"";
}
//判断时间地点是否已经填写
- (void)pushBtnType:(NSString *)str
{
    [_writeData.DiDianText resignFirstResponder];
    [_writeData.dataText resignFirstResponder];
    _querendeStr = str;
    if (_writeData.DiDianText.text.length <= 0) {
        _alertStr1 = @"请填写见面地点";
        [self alertView1Str];
        
    }else if (_writeData.dataText.text.length <= 0){
        _alertStr1 = @"请填写具体地址与电话";
        [self alertView1Str];
    }else{
        [self shijiandidianView];
    }
    
    
}

//添加时间与地点

- (void)shijiandidianView
{
    if ([_querendeStr isEqualToString:@"确认"]) {

        self.isTime = YES;

        if (_addCount == 1) {
            _writeData.hidden = YES;
            _piker1.hidden = YES;
            _Choosetime1.hidden = NO;
            self.rightButton.enabled = YES;
            _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
            _Choosetime1.TimeLable.text = [NSString stringWithFormat:@"%@ %@:%@",[_showDayArray objectAtIndex:[_piker1.pikerTime selectedRowInComponent:0]],[_hourArray objectAtIndex:[_piker1.pikerTime selectedRowInComponent:1]],[_minuteArray objectAtIndex:[_piker1.pikerTime selectedRowInComponent:2]]];
            _Choosetime1.SiztTitleLable.text = _writeData.DiDianText.text;
            _Choosetime1.SiztDetails.text = _writeData.dataText.text;
            _Choosetime1.NumberLable.text = [NSString stringWithFormat:@"%d",_addCount];
        }
        if (_addCount == 2) {
            _writeData.hidden = YES;
            _piker2.hidden = YES;
            _Choosetime1.hidden = NO;
            _Choosetime2.hidden = NO;
            self.rightButton.enabled = YES;
            _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
            _Choosetime2.frame = CGRectMake(0, 170, WIDTH(self.view), 150);
            _Choosetime2.TimeLable.text =  [NSString stringWithFormat:@"%@ %@:%@",[_showDayArray objectAtIndex:[_piker2.pikerTime selectedRowInComponent:0]],[_hourArray objectAtIndex:[_piker2.pikerTime selectedRowInComponent:1]],[_minuteArray objectAtIndex:[_piker2.pikerTime selectedRowInComponent:2]]];
            _Choosetime2.SiztTitleLable.text = _writeData.DiDianText.text;
            _Choosetime2.SiztDetails.text = _writeData.dataText.text;
            _Choosetime2.NumberLable.text = [NSString stringWithFormat:@"%d",_addCount];
        }
        if (_addCount == 3) {
            _writeData.hidden = YES;
            _piker3.hidden = YES;
            _Choosetime1.hidden = NO;
            _Choosetime2.hidden = NO;
            _Choosetime3.hidden = NO;
            self.rightButton.enabled = YES;
            _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
            _Choosetime2.frame = CGRectMake(0, 170, WIDTH(self.view), 150);
            _Choosetime3.frame = CGRectMake(0, 330, WIDTH(self.view), 150);
            _Choosetime3.TimeLable.text = [NSString stringWithFormat:@"%@ %@:%@",[_showDayArray objectAtIndex:[_piker3.pikerTime selectedRowInComponent:0]],[_hourArray objectAtIndex:[_piker3.pikerTime selectedRowInComponent:1]],[_minuteArray objectAtIndex:[_piker3.pikerTime selectedRowInComponent:2]]];
            _Choosetime3.SiztTitleLable.text = _writeData.DiDianText.text;
            _Choosetime3.SiztDetails.text = _writeData.dataText.text;
            _Choosetime3.NumberLable.text = [NSString stringWithFormat:@"%d",_addCount];
        }
    } else {
        self.isTime = NO;
    }
}


- (void)buttonClick:(UIButton *)sender
{

    if(self.isTime){
        [self alertViewStr];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择约见时段" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

}
- (void)alertViewStr {
    
    _didianStr = @"0";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交后无法修改" message:[@"提交后时间地点如有变更" stringByAppendingFormat:@"\n可在学员付款后通过私信或者电话联系"] delegate:self cancelButtonTitle:@"提交" otherButtonTitles:@"返回修改", nil];
    [alert show];
}


- (void)alertView1Str
{
    _didianStr = @"1";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_alertStr1 message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}


//提交审核

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([_didianStr isEqual:@"0"]){
    if (buttonIndex == 0) {
//        NSString *strUrl = [NSString stringWithFormat:@"%@&requestType=%@",[KipoServerConfig serverURL],@"OtoSchoolMeetDateAddr_Api"];
        if (_addCount == 1) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[@{@"meetDate":_Choosetime1.TimeLable.text,@"meetAddrName":_Choosetime1.SiztTitleLable.text,@"meetAddr":_Choosetime1.SiztDetails.text}] options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary *params = @{@"requestType":@"OtoSchoolMeetDateAddr_Api",
                                    @"apiType":@"saveDateAddr",
                                    @"meetId":self.mid?self.mid:@"",
                                    @"dataList":jsonstring?jsonstring:@""
                                    };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                _button.userInteractionEnabled = YES;
                
                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if([vc isKindOfClass:[MyStudensController class]]){
                            
                            MyStudensController * csController = (MyStudensController*)vc;
                            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationMeet object:nil];
                            
                            [self.navigationController popToViewController:csController animated:YES];
                            return;
                        }
                    }
                }else{
//                    [LCProgressHUD showFailure:responseObj[@"status_code"]];
                }

            }];

        }
        if (_addCount == 2) {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[@{@"meetDate":_Choosetime1.TimeLable.text,@"meetAddrName":_Choosetime1.SiztTitleLable.text,@"meetAddr":_Choosetime1.SiztDetails.text},@{@"meetDate":_Choosetime2.TimeLable.text,@"meetAddrName":_Choosetime2.SiztTitleLable.text,@"meetAddr":_Choosetime2.SiztDetails.text}] options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary *params = @{@"requestType":@"OtoSchoolMeetDateAddr_Api",
                                     @"apiType":@"saveDateAddr",
                                     @"meetId":self.mid?self.mid:@"",
                                     @"dataList":jsonstring?jsonstring:@""
                                     };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                _button.userInteractionEnabled = YES;
                
                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if([vc isKindOfClass:[MyStudensController class]]){
                            
                            MyStudensController * csController = (MyStudensController*)vc;
                            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationMeet object:nil];
                            
                            [self.navigationController popToViewController:csController animated:YES];
                            return;
                        }
                    }
                }else{
//                    [LCProgressHUD showFailure:responseObj[@"status_code"]];
                }

            }];

        }
        
        if (_addCount == 3) {
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@[@{@"meetDate":_Choosetime1.TimeLable.text,@"meetAddrName":_Choosetime1.SiztTitleLable.text,@"meetAddr":_Choosetime1.SiztDetails.text},@{@"meetDate":_Choosetime2.TimeLable.text,@"meetAddrName":_Choosetime2.SiztTitleLable.text,@"meetAddr":_Choosetime2.SiztDetails.text},@{@"meetDate":_Choosetime3.TimeLable.text,@"meetAddrName":_Choosetime3.SiztTitleLable.text,@"meetAddr":_Choosetime3.SiztDetails.text}] options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonstring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary *params = @{@"requestType":@"OtoSchoolMeetDateAddr_Api",
                                     @"apiType":@"saveDateAddr",
                                     @"meetId":self.mid?self.mid:@"",
                                     @"dataList":jsonstring?jsonstring:@""
                                     };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                _button.userInteractionEnabled = YES;
                
                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                    for (UIViewController *vc in self.navigationController.viewControllers) {
                        if([vc isKindOfClass:[MyStudensController class]]){
                            
                            MyStudensController * csController = (MyStudensController*)vc;
                            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationMeet object:nil];
                            
                            [self.navigationController popToViewController:csController animated:YES];
                            return;
                        }
                    }
                }else{
//                    [LCProgressHUD showFailure:responseObj[@"status_code"]];
                }

            }];

        }
        
    } else {
        
    }
    }

}
- (void)deleteNymber:(NSString *)number
{
//    if (_addCount == 0) {
//        _myScrollView.hidden = NO;
//        _addTimeAndDD.hidden = YES;
//    }
    if (_addCount == 1) {
        _addCount -= 1;
        _Choosetime1.hidden = YES;
        _myScrollView.hidden = YES;
        _addTimeAndDD.hidden = NO;
    }
    if (_addCount == 2) {
        if ([number isEqualToString:@"1"]) {
            //                [_deleDataArr addObject:number];
            _addCount -= 1;
            //                cellChange = _Choosetime2;
            _Choosetime2.hidden = YES;
            _Choosetime1.TimeLable.text = _Choosetime2.TimeLable.text;
            _Choosetime1.SiztTitleLable.text = _Choosetime2.SiztTitleLable.text;
            _Choosetime1.SiztDetails.text = _Choosetime2.SiztDetails.text;
            
            //                _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
            //                _Choosetime1.NumberLable.text = [NSString stringWithFormat:@"%d",_addCount];
        }
        if ([number isEqualToString:@"2"]) {
            //                [_deleDataArr addObject:number];
            _addCount -= 1;
            _Choosetime2.hidden = YES;
        }
    }
    
    if (_addCount == 3) {
        if ([number isEqualToString:@"1"]) {
            //            [_deleDataArr addObject:number];
            _addCount -= 1;
            _Choosetime3.hidden = YES;
            _Choosetime1.TimeLable.text = _Choosetime2.TimeLable.text;
            _Choosetime1.SiztTitleLable.text = _Choosetime2.SiztTitleLable.text;
            _Choosetime1.SiztDetails.text = _Choosetime2.SiztDetails.text;
            
            _Choosetime2.TimeLable.text = _Choosetime3.TimeLable.text;
            _Choosetime2.SiztTitleLable.text = _Choosetime3.SiztTitleLable.text;
            _Choosetime2.SiztDetails.text = _Choosetime3.SiztDetails.text;
            
            //            _Choosetime1.frame = CGRectMake(0, 10, WIDTH(self.view), 150);
            //            _Choosetime2.frame = CGRectMake(0, 170, WIDTH(self.view), 150);
            //            _Choosetime1.NumberLable.text = [NSString stringWithFormat:@"%d",1];
            //            _Choosetime2.NumberLable.text = [NSString stringWithFormat:@"%d",2];
        }
        if ([number isEqualToString:@"2"]) {
            //            [_deleDataArr addObject:number];
            _addCount -= 1;
            _Choosetime3.hidden = YES;
            _Choosetime2.TimeLable.text = _Choosetime3.TimeLable.text;
            _Choosetime2.SiztTitleLable.text = _Choosetime3.SiztTitleLable.text;
            _Choosetime2.SiztDetails.text = _Choosetime3.SiztDetails.text;
            
        }
        if ([number isEqualToString:@"3"]) {
            //            [_deleDataArr addObject:number];
            _Choosetime3.hidden = YES;
            _addCount -= 1;
        }
    }
    
    //    if ([number isEqualToString:@"1"]) {
    //        [_deleDataArr addObject:number];
    //        _piker2.frame = CGRectMake(0, 0, WIDTH(self.view), 180);
    //    }
}

#pragma mark-UIPiker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 15;
    } else if (component == 1)
    {
       return  self.hourArray.count;
    } else
    {
        return self.minuteArray.count;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSInteger firstComponentSelectedRow = [pickerView selectedRowInComponent:0];
//    if (component == 0)
//    {
//        _showDayArray;
//        
//    }
    //当第一列滑到第一个位置时，第二，三列滚回到0位置
    if(component == 0)
    {
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    if (firstComponentSelectedRow == 0)
    {
        _hourArray = [self validHourArray];
        _minuteArray = self.minutes;
        
    }else
    {
        _hourArray = HOURARRAYUSFou;
        _minuteArray = self.minutes;
    }

    [pickerView reloadAllComponents];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] init];
    myView.backgroundColor = [UIColor clearColor];
    myView.textAlignment = NSTextAlignmentRight;
    if (component == 0) {
        
        myView.frame = CGRectMake(10, 0.0, 150, 20);
        myView.font = [UIFont systemFontOfSize:12];
        myView.text = [NSString stringWithFormat:@"%@",self.showDayArray[row]];
  
    }else if (component == 1){
        
        myView.frame = CGRectMake(0.0, 0.0, 50, 20);
        myView.font = [UIFont systemFontOfSize:14];
        myView.text = [NSString stringWithFormat:@"%@",self.hourArray[row]];
//        _hourStr = [NSString stringWithFormat:@"%@",self.hourArray[row]];
        
    } else {
        myView.frame = CGRectMake(0.0, 0.0, 50, 20);
        myView.font = [UIFont systemFontOfSize:14];
        myView.text = [NSString stringWithFormat:@"%@",self.minutes[row]];
//        _minutesStr = [NSString stringWithFormat:@"%@",self.minutes[row]];
    }
//    _dateStr = [NSString stringWithFormat:@"%@ %@:%@",_dayStr,_hourStr,_minutesStr];
    return myView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}




// 当前小时
-(NSArray *)validHourArray
{
    int startIndex = [TRZXPersonalAppointmentPch currentDateHour];
    if ([TRZXPersonalAppointmentPch currentDateMinute] >= 60)
    {
        startIndex++;
    }
    return [HOURARRAYUSFou subarrayWithRange:NSMakeRange(startIndex+1, HOURARRAYUSFou.count - startIndex-1)];
}

-(NSArray *)validMinuteArray
{
    int startIndex = [TRZXPersonalAppointmentPch currentDateMinute]  +1;
    if ([TRZXPersonalAppointmentPch currentDateMinute] >= 60)
    {
       startIndex = 0;
    }
    
    return [self.minutes subarrayWithRange:NSMakeRange(startIndex, self.minutes.count - startIndex)];
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
