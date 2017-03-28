//
//  ChuangJianZhuTiVC.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//


#define moban1 @"zhuti1"
#define moban2 @"zhuti2"
#define link1 @"link1"
#define link2 @"link2"
#define mobanIndex @"zhutiIndex"

#import "ChuangJianZhuTiVC.h"
#import "ZhutideModel.h"
#import "IntroductionTableViewCell.h"
#import "ZhuTiBotomTableViewCell.h"
#import "ZhuTiMoneyTableViewCell.h"
#import "TZROne1TableViewCell.h"
#import "TZRTwoTableViewCell.h"
#import "ZhuTiTopView.h"
#import "ThemeViewController.h"
#import "ZhuTiMoBanViewController.h"
//#import "KipoUpLocationManage.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "TRZXMyThemePch.h"


@interface ChuangJianZhuTiVC ()<UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,zhutiBackDelegate>

{
    UITextField * _themeField;
    UITextView *_textView;
    UITextField * _priceField;
    UILabel * _zdLabel;
    NSString * yuejian;
    UIPickerView *sexPickerView;
    UIView *bigView;
    UIView *actionView;
    UIButton *queRenBtn;
    UIButton *quXiaoBtn;
}

@property (nonatomic,assign)NSInteger maxCount;

@property (weak, nonatomic)UIButton *selectedBtn;
@property (weak, nonatomic)UIButton *selected1Btn;

@property (copy, nonatomic)NSString *oneID;
@property (copy, nonatomic)NSString *twoID;
@property (copy, nonatomic)NSString *oneMID;
@property (copy, nonatomic)NSString *twoMID;
@property (copy, nonatomic)NSString *buchuanID;
@property (strong, nonatomic) ZhutideModel *mode;
@property (strong, nonatomic) NSArray *oneArr;
@property (strong, nonatomic)NSArray *twoArr;
@property (strong, nonatomic)NSArray *arr;
@property (strong, nonatomic) UILabel *theme_Lable;

@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonnull) ZhuTiTopView * ZhuTiTopView;
@property (strong,nonatomic)NSUserDefaults *standUser;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UILabel * gsLabel;

@end

@implementation ChuangJianZhuTiVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark - 提交审核
-(void)footerButtonAction:(UIButton*)sender{

    [self saveBtnClick:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主题";

    self.standUser = [NSUserDefaults standardUserDefaults];
    _oneArr = [[NSArray alloc] init];
    _twoArr = [[NSArray alloc] init];
    self.view.backgroundColor = backColor;

    [self createTableView];


    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = TRZXMainColor;
    [self.submitButton setTitle:@"发布主题" forState:UIControlStateNormal];
    self.submitButton.frame = CGRectMake(0, _myTableView.frame.origin.y+_myTableView.bounds.size.height, self.view.frame.size.width, 50);
    [self.submitButton addTarget:self action:@selector(footerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:self.submitButton];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    _themeField = [[UITextField alloc] init];
    _textView = [[UITextView alloc]init];
    _priceField = [[UITextField alloc] init];
    _theme_Lable = [[UILabel alloc]init];
    _themeCategory = [[UILabel alloc]init];
    _gsLabel = [[UILabel alloc]init];
    _zdLabel = [[UILabel alloc]init];
    _priceField.text = self.price;
    _themeField.text = self.topic;
    _textView.text = self.abstracts;
    //themeCategory=self

    [self request_Api];//暂时的先把分类删除

}


- (void)request_Api {
    NSDictionary *params = @{
                            @"requestType":@"OtoSchoolArea_Api",
                            @"apiType":@"findAreaByTopicAdd"
                            };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        _oneArr = [ZhutideModel mj_objectArrayWithKeyValuesArray:responseObj[@"areas"]];
        _arr = responseObj[@"areas"];
        if (_arr.count > 0) {
            NSDictionary *dic = [_arr objectAtIndex:0];
            NSArray *arr1 = dic[@"childerList"];
            _twoArr = [Childerlist mj_objectArrayWithKeyValuesArray:arr1];
        }
        if (_oneArr.count > 0) {
            Childerlist *childer = [_twoArr objectAtIndex:0];
            ZhutideModel *mode = [_oneArr objectAtIndex:0];
            _oneID = mode.name;
            _twoID = childer.name;
            _themeCategory.text = childer.name;
            _oneMID = mode.mid;
            _twoMID = childer.mid;
        }
        [sexPickerView reloadAllComponents];
        //重新跟新tableview导致了150字的问题
        //[_myTableView reloadData];
        
    }];

}
- (void)createTableView {
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view)-50)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = backColor;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    //先屏蔽了
//    self.myTableView.tableHeaderView.height = 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1) {
        return 90;
    }else if (indexPath.section == 2) {
        return 200;
    }else if (indexPath.section == 3) {
        return 60;
    }else {
        return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        TZROne1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZROne1TableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TZROne1TableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        cell.titleField.tag = 10105;
        cell.titleField.delegate = self;
        cell.titleField.placeholder = @"例如：如何进行b轮及以后的融资";
        cell.titleLabel.text = @"主题名称";
//        [cell.titleField addTarget:self action:@selector(textWillChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.titleField.delegate = self;
        cell.titleField.text = _themeField.text;
        [cell.titleField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        _themeField = cell.titleField;
        _theme_Lable = cell.danweiLabel;
        if (_theme_Lable.text.length <21) {
            _theme_Lable.text = [NSString stringWithFormat:@"%lu字",20-_themeField.text.length];
        } else {
            NSString *subText = [_theme_Lable.text substringToIndex:20];
            _theme_Lable.text = subText;
        }
        return cell;

    }else if (indexPath.section == 1){
        TZRTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TZRTwoTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TZRTwoTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.tiaozhuanBtn addTarget:self action:@selector(fenleiClick:) forControlEvents:UIControlEventTouchUpInside];//暂时先屏蔽
        cell.yanzhanImage.hidden = YES;
        cell.backgroundColor = backColor;
        cell.titleLabel.text = @"主题分类";
        cell.zhanshiLabel.text = _themeCategory.text;
        _themeCategory = cell.zhanshiLabel;
        return cell;
    }else if (indexPath.section == 2) {
        IntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroductionTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"IntroductionTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.mobanBtn.layer setCornerRadius:10];
        cell.mobanBtn.layer.masksToBounds = YES;
        cell.mobanBtn.backgroundColor = TRZXMainColor;
        [cell.mobanBtn addTarget:self action:@selector(moBanClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.IntroductionLabel.text = _textView.text;
        cell.IntroductionLabel.returnKeyType = UIReturnKeyDefault;
        _textView = cell.IntroductionLabel;

        cell.tag=8888;
        if(_textView.text.length>0){
            _gsLabel.text  = @"";
        }else{
            _gsLabel.text = @"例如：资本寒冬来临，最受冲击的是b轮开始的成长期融资。因此许多企业面临低价融资的窘境，被迫调整发展步伐，或是从事与格局不符的短期盈利业务。但是从另一个角度出发，我们也能够看到资本寒冬往往是建立结构性优势的契机。那么企业应该如何进行调整以应对当前的挑战？在这方面，相信我能够给你一些帮助。我专注b/c/d轮投资并经历了两轮熊市，将从成长期投资者角度给予创业公司建议。";
        }
        _zdLabel.text = @"3000字";
        cell.IntroductionLabel.delegate = self;
        cell.zuishaoLabel.text = _gsLabel.text;
        _gsLabel = cell.zuishaoLabel;
        cell.zishuLabel.text = _zdLabel.text;
        _zdLabel = cell.zishuLabel;
        cell.jianjieLabel.text = @"主题介绍";
        cell.backgroundColor = backColor;
        NSString *str = [self.standUser objectForKey:mobanIndex];
        if ([_wumobanStr isEqualToString:@"1"]) {
            if (_textView.text.length > 0) {
                cell.zuishaoLabel.hidden = YES;
                cell.zishuLabel.text = [NSString stringWithFormat:@"%ld字",3000-_textView.text.length];
            }
        }else  if ([str isEqualToString:@"0"]) {
            _textView.text = [self.standUser objectForKey:moban1];
            cell.zuishaoLabel.hidden = YES;
            cell.zishuLabel.text = [NSString stringWithFormat:@"%ld字",3000-_textView.text.length];
        }else if ([str isEqualToString:@"1"]) {
            _textView.text = [self.standUser objectForKey:moban2];
            cell.zuishaoLabel.hidden = YES;
            cell.zishuLabel.text = [NSString stringWithFormat:@"%ld字",3000-_textView.text.length];
        }
        
        return cell;
    }else if (indexPath.section == 3) {
        ZhuTiMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhuTiMoneyTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZhuTiMoneyTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        cell.bobanBtn.hidden = YES;
        [cell.bobanBtn addTarget:self action:@selector(moBanClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moneyField.text = _priceField.text;
        cell.moneyField.keyboardType =  UIKeyboardTypeNumberPad;
        _priceField = cell.moneyField;
        cell.moneyField.delegate = self;
        [cell.moneyField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        ZhuTiBotomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhuTiBotomTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZhuTiBotomTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        [cell.time1Btn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.time2Btn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.time3Btn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.time4Btn addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.oneToOneBtn addTarget:self action:@selector(yuejianClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.yuanchengBtn addTarget:self action:@selector(yuejianClick:) forControlEvents:UIControlEventTouchUpInside];

        if ([self.duration isEqualToString:@"1小时"]) {
            [self timeClick:cell.time1Btn];
        }else if ([self.duration isEqualToString:@"2小时"]){
            [self timeClick:cell.time3Btn];
        }else if ([self.duration isEqualToString:@"2小时以上"]){
            [self timeClick:cell.time4Btn];
        }
//        if ([self.yuancheng isEqualToString:@"线下咨询"]) {
//            [self yuejianClick:cell.yuanchengBtn];
//        }else if ([self.yuancheng isEqualToString:@"线上咨询"]) {
//            [self yuejianClick:cell.oneToOneBtn];
//        }
        return cell;
    }
}


- (void)createSexView
{
    bigView = [[UIView alloc] initWithFrame:self.view.frame];
    bigView.backgroundColor =[UIColor clearColor];
    bigView.userInteractionEnabled = NO;
    [self.view addSubview:bigView];
    actionView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGTH(self.view), WIDTH(self.view), 200)];
    actionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:actionView];
    sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 200)];
    sexPickerView.delegate = self;
    sexPickerView.dataSource = self;
    sexPickerView.showsSelectionIndicator = YES;
    [sexPickerView selectRow:0 inComponent:0 animated:YES];
    [sexPickerView selectRow:0 inComponent:1 animated:YES];
    [actionView addSubview:sexPickerView];
    quXiaoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    quXiaoBtn.frame = CGRectMake(5, 7, 50, 25);
    [quXiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quXiaoBtn addTarget:self action:@selector(quxiaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [quXiaoBtn setTitleColor:TRZXMainColor forState:UIControlStateNormal];
    [actionView addSubview:quXiaoBtn];
    queRenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [queRenBtn setTitle:@"完成" forState:UIControlStateNormal];
    [queRenBtn setTitleColor:TRZXMainColor forState:UIControlStateNormal];
    [queRenBtn addTarget:self action:@selector(queRenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    queRenBtn.frame = CGRectMake(WIDTH(self.view)-55, 7, 50, 25);
    [actionView addSubview:queRenBtn];


}

- (void)quxiaoBtnClick:(UIButton *)sender
{

    [self hidePickerView];

}

- (void)queRenBtnClick:(UIButton *)sender
{
    [self hidePickerView];
    _themeCategory.text = [NSString stringWithFormat:@"%@-%@",_oneID,_twoID];
}

-(void)showPickerView
{

    bigView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        bigView.backgroundColor = [UIColor blackColor];
        bigView.alpha = 0.6;
        actionView.frame = CGRectMake(0, HEIGTH(self.view)-HEIGTH(actionView), WIDTH(actionView), HEIGTH(actionView));
    } completion:^(BOOL finished) {

    }];

}
-(void)hidePickerView
{
    bigView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        bigView.backgroundColor = [UIColor clearColor];
        actionView.frame = CGRectMake(0, HEIGTH(self.view), WIDTH(actionView), HEIGTH(actionView));
    } completion:^(BOOL finished) {

    }];

}

#pragma mark - pikerView;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//每个组件的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _oneArr.count;
    } else {
        return _twoArr.count;

    }
}

//初始化每个组件每一行数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        ZhutideModel *Areas1e = [_oneArr objectAtIndex:row];
        return Areas1e.name;
    } else {
        Childerlist *childer = [_twoArr objectAtIndex:row];
        return childer.name;
    }
}
//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        ZhutideModel *Areas1 = [_oneArr objectAtIndex:row];
        _oneID = Areas1.name;
        _oneMID = Areas1.mid;
        NSDictionary *dic = [_arr objectAtIndex:row];
        NSArray *arr1 = dic[@"childerList"];
        _twoArr = [Childerlist mj_objectArrayWithKeyValuesArray:arr1];
        if (_twoArr.count == 0) {
            _twoID = @"";
            _twoMID = @"";
        } else {
            Childerlist *childer = [_twoArr objectAtIndex:0];
            _twoID = childer.name;
            _twoMID = childer.mid;

        }
        [sexPickerView reloadComponent:1];
        [sexPickerView selectRow:0 inComponent:1 animated:YES];
    } else {
        if (_twoArr.count == 0) {
            _twoID = @"";
            _twoMID = @"";
        } else {
            Childerlist *childer = [_twoArr objectAtIndex:row];
            _twoID = childer.name;
            _twoMID = childer.mid;
        }
    }
}


//模板事件
- (void)moBanClick:(UIButton *)sender{
    [_textView resignFirstResponder];
    ZhuTiMoBanViewController * mobanController = [[ZhuTiMoBanViewController alloc]init];
    mobanController.delegate = self;
    [self.navigationController pushViewController:mobanController animated:true];
}
//时间事件
- (void)timeClick:(UIButton *)sender{

    self.selectedBtn.selected = NO;
    self.selectedBtn.backgroundColor = backColor;
    [self.selectedBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
    sender.selected = YES;
    self.duration = sender.titleLabel.text;
    sender.backgroundColor = TRZXMainColor;
    self.selectedBtn = sender;

}
//约见事件
- (void)yuejianClick:(UIButton *)sender{

    self.selected1Btn.selected = NO;
    [self.selectedBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateHighlighted];
    self.selected1Btn.backgroundColor = backColor;
    sender.selected = YES;
    yuejian = sender.titleLabel.text;
    sender.backgroundColor = TRZXMainColor;
    self.selected1Btn = sender;

}
//样例事件
- (void)yangliClick:(UIButton *)sender{
    ThemeViewController * mobanController = [[ThemeViewController alloc]init];
    if (sender.tag == 1010) {
        mobanController.titleStr = @"标准样例";
    }else if (sender.tag == 1011){
        mobanController.titleStr = @"个性样例";
    }else if (sender.tag == 1012){
        mobanController.titleStr = @"文艺样例";
    }
    [self.navigationController pushViewController:mobanController animated:true];
}
//键盘响应
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_priceField resignFirstResponder];
    [_themeField resignFirstResponder];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    [_textView resignFirstResponder];
    [_priceField resignFirstResponder];
    [_themeField resignFirstResponder];
}
//模板返回事件
- (void)pushZhuTiBack:(NSString *)anliStr{
    _textView.text = anliStr;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    IntroductionTableViewCell *cell = [_myTableView cellForRowAtIndexPath:indexPath];
    cell.zuishaoLabel.hidden = YES;
    cell.zishuLabel.text = [NSString stringWithFormat:@"%lu字",3000-anliStr.length];
}
//返回
- (void)goBackView:(UIButton *)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

//选分类
- (void)fenleiClick:(UIButton *)sender {
    
    [_textView resignFirstResponder];
    [_priceField resignFirstResponder];
    [_themeField resignFirstResponder];
    [self createSexView];
    [self showPickerView];

}



- (void)alertViewStr:(NSString *)str1 with:(NSString *)str2 {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag = 500;
    [alert show];
}

- (void)alertViewStr {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认发布该主题" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    alert.tag = 600;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 600) {
        if (buttonIndex == 0) {
            //创建主题
            if (!self.themeID.length) {
                NSDictionary *params = @{
                                        @"requestType":@"OtoSchoolTopic_Api",
                                        @"apiType":@"saveTopic",
                                        @"topicTitle":_themeField.text?_themeField.text:@"",
                                        @"topicContent":_textView.text?_textView.text:@"",
                                        @"timeOnce":self.duration?self.duration:@"",
                                        @"muchOnce":_priceField.text?_priceField.text:@"",
                                        @"oneAreaId":_oneMID?_oneMID:@"",
                                        @"twoAreaId":_twoMID?_twoMID:@"",
                                        @"topicType":@"0"
                                        };
                 [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                    
                    [self.view endEditing:YES];
                    if ([responseObj[@"status_code"] isEqualToString:@"200"]) {

                        //上传位置信息(先注销)
//                        KipoUpLocationManage *manage = [KipoUpLocationManage sharedManager];
//                        [manage startLocation];

                        
//                        [LCProgressHUD showSuccess:@"发布成功"];
                        [self.delegate pushZhuTiDe];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
//                        [LCProgressHUD showFailure:@"发布失败"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObj[@"status_dec"] message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];

            } else {
//审核失败后修改主题
                NSDictionary *params = @{
                                        @"requestType":@"OtoSchoolTopic_Api",
                                        @"apiType":@"updateTopic",
                                        @"topicTitle":_themeField.text?_themeField.text:@"",
                                        @"topicContent":_textView.text?_textView.text:@"",
                                        @"timeOnce":self.duration?self.duration:@"",
                                        @"muchOnce":_priceField.text?_priceField.text:@"",
                                        @"id":self.themeID?self.themeID:@"",
                                        @"epId":self.epId?self.epId:@"",
                                        @"oneAreaId":_oneMID?_oneMID:@"",
                                        @"twoAreaId":_twoMID?_twoMID:@"",
                                        @"topicType":@"0"
                                        };
                [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                    
                    [self.view endEditing:YES];
                    if ([responseObj[@"status_code"] isEqualToString:@"200"]) {


                        //上传位置信息（先注销）
//                        KipoUpLocationManage *manage = [KipoUpLocationManage sharedManager];
//                        [manage startLocation];

//                        [LCProgressHUD showSuccess:@"修改成功"];
                        [self.delegate pushZhuTiDe];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationTheme object:nil];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    } else {
//                        [LCProgressHUD showFailure:@"修改失败"];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObj[@"status_dec"] message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                }];
            }
        } else {

        }
    } else {

    }

}

//- (void)textChanged:(UITextField *)textfield
//{
//
//    if (textfield.tag == 10105) {
//        if (textfield.text.length <21) {
//            _theme_Lable.text = [NSString stringWithFormat:@"%lu字",20-textfield.text.length];
//        } else {
//            NSString *subText = [textfield.text substringToIndex:20];
//            textfield.text = subText;
//        }
//    }
//
//    if (textfield.tag == 86012) {
//        if (textfield.text.length == 0) {
//
//        } else {
//            if ([[textfield.text substringToIndex:1] isEqualToString:@"0"]) {
//                [self alertViewStr:nil with:@"请正确输入金额"];
//                textfield.text = @"0";
//            } else {
//                if (textfield.text.length <= 5) {
//                } else {
//                    NSString *subText = [textfield.text substringToIndex:5];
//                    textfield.text = subText;
//                }
//            }
//        }
//    }
//
//}
#pragma  mark - 文本改变的通知
- (void)textChanged:(UITextField *)textField
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (textField.tag == 10105) {
        _maxCount = 20;
    }
    if (textField.tag == 86012) {
        _maxCount = 5;
        if (textField.text.length == 0) {

        } else {
            if ([[textField.text substringToIndex:1] isEqualToString:@"0"]) {
                [self alertViewStr:nil with:@"请正确输入金额"];
                textField.text = @"";
            } else {
                if (textField.text.length <= 5) {
                } else {
                    NSString *subText = [textField.text substringToIndex:5];
                    textField.text = subText;
                }
            }
        }
        return;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.maxCount) {
                textField.text = [toBeString substringToIndex:self.maxCount];
            }
            _theme_Lable.text = [NSString stringWithFormat:@"%lu字",20-textField.text.length];
        }else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
            return;
            
        }
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > self.maxCount) {
            textField.text = [toBeString substringToIndex:self.maxCount];
        }
    }
    textField.text = [self disable_emoji:textField.text];
//    self.context = textField.text;
}

//禁止输入表情
- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma clang diagnostic pop

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.context = textField.text;
    textField.text = textField.text;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length == 0) {
        [_gsLabel setHidden:NO];
    }else{
        [_gsLabel setHidden:YES];
    }
    NSInteger count = 3000;
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > count) {
                textView.text = [toBeString substringToIndex:count];
            }
        }else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
            return;
        }
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > count) {
            textView.text = [toBeString substringToIndex:count];
        }
    }
    if(textView.text.length >= count){
        [textView scrollRangeToVisible:[textView.text rangeOfString:toBeString]];
    }
    
    _zdLabel.text  = [NSString stringWithFormat:@"%lu字",(count-textView.text.length)];
}
#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//保存事件
//- (void)saveClick:(UIButton *)sender{
- (void)saveBtnClick:(UIButton *)sender{
    if (_themeField.text.length < 2) {
        [self alertViewStr:@"主题名称最少两个字" with:@""];
    } else {
//        if (_themeCategory.text.length == 0) {
//            [self alertViewStr:@"请选择分类" with:@""];
//        } else {
            if (_textView.text.length < 150) {
                [self alertViewStr:@"主题介绍最少150个字" with:@""];
            } else {
                if ([_priceField.text isEqualToString:@""]) {
                    [self alertViewStr:@"请填写价格" with:@""];
                } else {
                    if ([[_priceField.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                        [self alertViewStr:@"输入的价格有误\n请重新填写价格" with:@""];
                        return;
                    }
                    if ([_priceField.text intValue] < 50) {
                        [self alertViewStr:@"价格不能低于50元\n请重新填写价格" with:@""];
                    } else {
#pragma mark 此处些限制‘050’问题的输入
                        if (self.duration.length == 0) {
                            [self alertViewStr:@"请选择约见时长" with:@""];
                        } else {
//                            if (yuejian.length == 0) {
//                                [self alertViewStr:@"" with:@"请选择约见方式"];
//                            } else {
                                [self alertViewStr];
//                            }
//                        }
                    }
                }
            }
        }
    }
}



@end
