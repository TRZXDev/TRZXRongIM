//
//  CancelViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "CancelViewController.h"

//#import "ConsultingDetailsViewController.h"
#import "MyExpertViewController.h"


#import "TRZXPersonalAppointmentPch.h"

@interface CancelViewController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *text1View;
    NSString * panduanStr;
    UIButton *submitBtn;
}

@property (strong, nonatomic)UITableViewCell *oldCell;

@property (strong, nonatomic)UILabel *textViewLable;
@property (strong, nonatomic)UILabel *numberLable;


@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"取消约见";
    self.view.backgroundColor = backColor;
    dataArr = @[@"最近时间安排有变,希望下次有机会再约",@"不小心拍错主题,多有打扰,抱歉",@"谢谢您,我的问题已经解决了",@"其他原因:请填写详情"];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, WIDTH(self.view), 200)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = backColor;
    
    myTableView.scrollEnabled = NO;
    
    [self.view addSubview:myTableView];
    
    [self qitaview];
    submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(0, HEIGTH(self.view)-50, WIDTH(self.view), 50);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = TRZXMainColor;
    [self.view addSubview:submitBtn];
}

- (void)submitClick:(UIButton *)sender
{

    if ([panduanStr isEqual:@"1"]) {
        if (_qxReason.length>0){
            submitBtn.userInteractionEnabled = NO;
            [self requestDisableMeet];
            
        } else {
//            [LCProgressHUD showInfoMsg:@"请选择或输入取消原因"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择或输入取消原因" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else {
        if (text1View.text.length>0){
            submitBtn.userInteractionEnabled = NO;
            [self requestDisableMeet];
            
        } else {
//            [LCProgressHUD showInfoMsg:@"请输入取消原因"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入取消原因" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    
}


#pragma mark - 取消约见信息

- (void)requestDisableMeet
{

    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"disableMeet",
                             @"id":_conventionId?_conventionId:@"",
                             @"qxReason":_qxReason,
                             @"meetStatus":[NSString stringWithFormat:@"%ld",(long)self.meetStase+1]
                             };
    if (self.meetStase == 13) {
        self.meetStase = 4;
    }
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        submitBtn.userInteractionEnabled = YES;
        
        if ([[object objectForKey:@"status_code"] isEqualToString:@"200"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消约见成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 2017314;
            [alert show];
            
        }
    }];
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 2017314) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            //那里跳的返回到那里 先注销了
            
//            if ([vc isKindOfClass:[ConsultingDetailsViewController class]]){
//                ConsultingDetailsViewController * csController = (ConsultingDetailsViewController*)vc;
//                
//                [self.navigationController popToViewController:csController animated:YES];
//                return;
//            }else if ([vc isKindOfClass:[MyExpertViewController class]]){
                MyExpertViewController * csController = (MyExpertViewController*)vc;
                
                [self.navigationController popToViewController:csController animated:YES];
                
                if (self.removePushVCBlock) {
                    self.removePushVCBlock();
                }
                
                return;
//            }
            
        }
    }
    

    


}

//- (void)tap:(UITapGestureRecognizer *)tap {
//    [self.view endEditing:YES];
//}

- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row != dataArr.count) {
//        return 50;
//    } else {
//        return 100;
//    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row < dataArr.count) {
        cell.textLabel.textColor = heizideColor;
        cell.textLabel.text = dataArr[indexPath.row];
    }
//    if (indexPath.row == dataArr.count) {
//        textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, WIDTH(self.view), 100)];
//        textView.delegate = self;
//        textView.font = [UIFont systemFontOfSize:15];
//        textView.textColor = heizideColor;
//        _textViewLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 140, 20)];
//        _textViewLable.text = @"请简单描述取消原因";
//        _textViewLable.font = [UIFont systemFontOfSize:13];
//        _textViewLable.textColor = [UIColor lightGrayColor];
//        [textView addSubview:_textViewLable];
//        
//        _numberLable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)-60, 80, 50, 20)];
//        _numberLable.text = @"100字";
//        _numberLable.font = [UIFont systemFontOfSize:13];
//        _numberLable.textColor = [UIColor lightGrayColor];
//        [textView addSubview:_numberLable];
//        
//        [cell.contentView addSubview:textView];
//    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < dataArr.count-1) {
        panduanStr = @"1";
        _qxReason = dataArr[indexPath.row];
        text1View.hidden = YES;
    }if (indexPath.row == 3) {
        panduanStr = @"0";
        text1View.hidden = NO;
    }

    _oldCell.contentView.backgroundColor = [UIColor whiteColor];
    _oldCell.textLabel.textColor = [UIColor blackColor];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = moneyColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    _oldCell = cell;
    
}

- (void)qitaview
{
    text1View = [[UITextView alloc] initWithFrame:CGRectMake(0, 274, WIDTH(self.view), 100)];
    text1View.delegate = self;
    text1View.font = [UIFont systemFontOfSize:15];
    text1View.textColor = heizideColor;
    _textViewLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 140, 20)];
    _textViewLable.text = @"请简单描述取消原因";
    _textViewLable.font = [UIFont systemFontOfSize:13];
    _textViewLable.textColor = [UIColor lightGrayColor];
    [text1View addSubview:_textViewLable];
    if ([text1View.text length] == 0) {
        [_textViewLable setHidden:NO];
    }else{
        [_textViewLable setHidden:YES];
    }
    if (text1View.text.length <=100) {
        _numberLable.text = [NSString stringWithFormat:@"%lu字",100-text1View.text.length];
    } else {
        NSString *subText = [text1View.text substringToIndex:100];
        text1View.text = subText;
    }

    _numberLable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)-60, 80, 50, 20)];
    _numberLable.text = @"100字";
    _numberLable.textAlignment = NSTextAlignmentRight;
    _numberLable.font = [UIFont systemFontOfSize:13];
    _numberLable.textColor = [UIColor lightGrayColor];
    [text1View addSubview:_numberLable];
    
    [self.view addSubview:text1View];
    text1View.hidden = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    if (![text isEqualToString:@""])
        
    {
        
        _textViewLable.hidden = YES;
//        _numberLable.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        _textViewLable.hidden = NO;
//        _numberLable.hidden = NO;
        
    }
    
    if (range.location >= 100) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    _qxReason = textView.text;
    if (textView.text.length == 0) {
        [_textViewLable setHidden:NO];
    }else{
        [_textViewLable setHidden:YES];
    }
    NSInteger count = 100;
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
    
    _numberLable.text  = [NSString stringWithFormat:@"%lu字",(count-textView.text.length)];
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
