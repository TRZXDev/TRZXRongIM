//
//  LoadEvaluateController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "LoadEvaluateController.h"
#import "TRZXPJiDuView.h"
#import "TRZXPStar.h"
#import "YesEvaluateController.h"
#import "MeetModel.h"
#import "TRZXPersonalAppointmentPch.h"

@interface LoadEvaluateController () <starDelegate,UITextViewDelegate>

@property (strong, nonatomic)UILabel *numberLable;
@property (strong, nonatomic)UILabel *dateLable;
@property (strong, nonatomic)TRZXPJiDuView *jinduView;
@property (strong, nonatomic) UIImageView *icimage;
@property (strong, nonatomic) UILabel *nameLable;
@property (strong, nonatomic) UILabel *moneyLable;
@property (strong, nonatomic)UILabel *timeLable;
@property (strong, nonatomic) UILabel *textLable;
@property (strong, nonatomic) TRZXPStar *star;

@property (strong, nonatomic) UILabel *textView_lable;

@property (strong, nonatomic) UILabel *word_Number;

@property (strong, nonatomic) MeetModel *meetModel;

@property (strong, nonatomic) UITextView *evaluate_TextView;

@property (copy, nonatomic) NSString *soureStr;

@property (strong, nonatomic) UIView *evaluateView;
@property (strong, nonatomic) UIView *cellView;
@property (strong, nonatomic)  UIButton *ConfirmBtn;


@end

@implementation LoadEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评价";
    _soureStr = @"0";
    
    _ConfirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _ConfirmBtn.frame = CGRectMake(0, HEIGTH(self.view)-50, WIDTH(self.view), 50);
    [_ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_ConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_ConfirmBtn setBackgroundColor:TRZXMainColor];
    [_ConfirmBtn addTarget:self action:@selector(ConfirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ConfirmBtn];
    self.view.backgroundColor = backColor;
    [self request_APi];
}

- (void)request_APi {
    
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
            [self _cellView];
            [self _evaluateView];
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
        [_jinduView JiDuNow:5 with:5];
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

- (void)_cellView {
    _cellView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, WIDTH(self.view)-20, 105)];
    _cellView.backgroundColor = moneyColor;
    _cellView.layer.cornerRadius = 10;
    _cellView.layer.masksToBounds = YES;
    [self.view addSubview:_cellView];

    _icimage = [[UIImageView alloc] init];
    _icimage.layer.cornerRadius = 6;
    _icimage.layer.masksToBounds = YES;
    [_cellView addSubview:_icimage];
    [_icimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellView.mas_top).offset(15);
        make.left.equalTo(_cellView.mas_left).offset(25);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];
    
    _nameLable = [[UILabel alloc] init];
    _nameLable.textColor = [UIColor whiteColor];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.text = @"阿萨德";
    _nameLable.textAlignment = NSTextAlignmentCenter;
    [_cellView addSubview:_nameLable];
    
    [_nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellView.mas_top).offset(70);
        make.centerX.equalTo(_icimage.mas_centerX);
        //        make.left.equalTo(_cellView.mas_left);
        make.width.equalTo(@(85));
        make.height.equalTo(@(30));
    }];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.textColor = [UIColor whiteColor];
    _timeLable.text = @"约1.5个小时";
    _timeLable.textAlignment = NSTextAlignmentRight;
    _timeLable.font = [UIFont systemFontOfSize:13];
    [_cellView addSubview:_timeLable];
    
    [_timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellView.mas_top).offset(20);
        make.right.equalTo(_cellView.mas_right).offset(-30);
        make.height.equalTo(@(15));
        make.width.equalTo(@(80));
    }];
    
    _moneyLable = [[UILabel alloc] init];
    _moneyLable.textColor = [UIColor whiteColor];
    _moneyLable.text = @"300元/次";
    _moneyLable.textAlignment = NSTextAlignmentRight;
    _moneyLable.font = [UIFont systemFontOfSize:13];
    [_cellView addSubview:_moneyLable];
    
    [_moneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellView.mas_top).offset(20);
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
    [_cellView addSubview:_textLable];
    
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cellView.mas_top).offset(40);
        make.left.equalTo(_cellView.mas_left).offset(100);
        make.right.equalTo(_cellView.mas_right).offset(-30);
        //        make.height.equalTo(@(50));
    }];
    
}

- (void)_evaluateView {
    _evaluateView = [[UIView alloc] initWithFrame:CGRectMake(10, 270, WIDTH(self.view)-20, 140)];
    _evaluateView.backgroundColor = [UIColor whiteColor];
    _evaluateView.layer.cornerRadius = 10;
    [self.view addSubview:_evaluateView];

    UILabel *evaluate_Title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    evaluate_Title.text = @"为专家做出评价";
    evaluate_Title.textColor = TRZXMainColor;
    evaluate_Title.font = [UIFont systemFontOfSize:13];
    [_evaluateView addSubview:evaluate_Title];
    
    _star= [[TRZXPStar alloc]initWithFrame:CGRectMake(10, 30, 130, 30)];
    //    star.empty_color = [UIColor whiteColor];
    _star.full_color = [UIColor yellowColor];
    _star.font_size = 25;
    _star.delegate = self;
//    _star.show_star = _dataMode.praiseCount*20;
//    Starmark = _dataMode.praiseCount;
    _star.isSelect = YES;
    [_evaluateView addSubview:_star];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 65, WIDTH(self.view)-40, 1)];
    lineView.backgroundColor = xiandeColor;
    [_evaluateView addSubview:lineView];
    
    _evaluate_TextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, WIDTH(self.view)-40, 55)];
    _evaluate_TextView.delegate = self;
    [_evaluateView addSubview:_evaluate_TextView];
    
    
    _textView_lable= [[UILabel alloc] initWithFrame:CGRectMake(2, 4, 230, 20)];
    _textView_lable.text = @"写下对专家的感受,对他人帮助很大哦";
    _textView_lable.font = [UIFont systemFontOfSize:13];
    _textView_lable.textColor = zideColor;
    [_evaluate_TextView addSubview:_textView_lable];
    
    _word_Number = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(_evaluateView)-55, 125, 50, 15)];
    _word_Number.text = @"150字";
    _word_Number.textColor = [UIColor lightGrayColor];
    _word_Number.font = [UIFont systemFontOfSize:15];
    [_evaluateView addSubview:_word_Number];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([_evaluate_TextView.text length] == 0) {
        [_textView_lable setHidden:NO];
    }else{
        [_textView_lable setHidden:YES];
    }
    
    if (textView.text.length > 150) {
        textView.text = [textView.text substringToIndex:150];
    }
    
    _word_Number.text = [NSString stringWithFormat:@"%lu字",150-textView.text.length];
    
    //    [self moveKeyboard];
}


#pragma mark - 星系的代理
- (void)starMark:(NSInteger)mark
{
    _soureStr = [NSString stringWithFormat:@"%li",(long)mark];
    
}

- (void)goBackView:(id)sender
{
    
    [self.delegate push1ZhuangTai];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if (_evaluate_TextView.text.length > 0) {
        _textView_lable.hidden = YES;
    }
    
    if (![text isEqualToString:@""])
        
    {
        _textView_lable.hidden = YES;
        
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        _textView_lable.hidden = NO;
        
    }

    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)ConfirmBtnClick:(UIButton *)sender
{
    if ([_soureStr isEqualToString:@"0"]) {
//        [LCProgressHUD showInfoMsg:@"请评分"]; // 显示提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请评分" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else if (_evaluate_TextView.text.length == 0) {
//        [LCProgressHUD showInfoMsg:@"请评价"]; // 显示提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请评价" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [self request_QueRen];
    }
}

- (void)request_QueRen {
    _ConfirmBtn.userInteractionEnabled = NO;

    NSDictionary *params = @{@"requestType":@"OtoSchoolMeet_Api",
                            @"apiType":@"saveMeetComment",
                            @"id":self.mid?self.mid:@"",
                            @"commentContent":_evaluate_TextView.text?_evaluate_TextView.text:@"",
                            @"score":_soureStr?_soureStr:@""
                            };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        _ConfirmBtn.userInteractionEnabled = YES;
        
        if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            [self alertViewStr];
        }
    }];

}


- (void)keyboardShow {

    [UIView animateWithDuration:2 animations:^{
        _evaluateView.frame = CGRectMake(10, 170, WIDTH(_evaluateView), HEIGTH(_evaluateView));
        _cellView.hidden = YES;
    }];
    
}
- (void)keyboardHide {
    [UIView animateWithDuration:2 animations:^{
        _evaluateView.frame = CGRectMake(10, 270, WIDTH(_evaluateView), HEIGTH(_evaluateView));
        _cellView.hidden = NO;
    }];
}
- (void)alertViewStr{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"感谢你对专家做出评价，专家已经收到你的约见费用" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 2017031402;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2017031402) {
        _YesEvaluateVc = [[YesEvaluateController alloc] init];
        _YesEvaluateVc.mid = self.mid;
        _YesEvaluateVc.vipPDStr = @"1";
        [self.delegate push1ZhuangTai];
        [self.navigationController pushViewController:_YesEvaluateVc animated:YES];
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
