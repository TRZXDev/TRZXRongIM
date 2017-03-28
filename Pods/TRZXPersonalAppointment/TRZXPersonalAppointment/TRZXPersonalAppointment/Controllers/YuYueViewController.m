//
//  YuYueViewController.m
//  tourongzhuanjia
//
//  Created by N年後 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "YuYueViewController.h"
#import "TRZXPJiDuView.h"
#import "LoadCountersignController.h"
#import "TRZBookingView.h"
#import "TRZXPersonalAppointmentPch.h"

@interface YuYueViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    NSString *conventionId;

}

@property (strong, nonatomic) TRZXPJiDuView *jinduView;
@property (strong, nonatomic) TRZBookingView *yuYueView;

@property (strong, nonatomic) UIView * yyView;


@end

@implementation YuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约";
    self.view.backgroundColor = backColor;
    [_nextBtn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
    _jinduView = [[TRZXPJiDuView alloc] initWithFrame:CGRectMake(0, 82, SCREEN_WIDTH, 12)];
    if ([_YuYueType isEqualToString:@"我的问题"]){
        [_jinduView JiDuNow:1 with:2];


    }else if ([_YuYueType isEqualToString:@"自我介绍"]){
        [_jinduView JiDuNow:2 with:2];

    }

    [self.view addSubview:_jinduView];
    NSArray *dataArr = @[@"我的问题",@"自我介绍"];
    for (int i = 0; i<2; i++) {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((i+1)*(SCREEN_WIDTH/3)-25, 95, 50, 20)];
        lable.text = dataArr[i];
        lable.font = [UIFont systemFontOfSize:10];
        lable.textColor = zideColor;

        if ([_YuYueType isEqualToString:@"我的问题"]){

            if (i==0){
                lable.textColor = [UIColor redColor];
            }
        }else if ([_YuYueType isEqualToString:@"自我介绍"]){

            if (i==1){
                lable.textColor = [UIColor redColor];
            }
        }
        
        [self.view addSubview:lable];
        
    }
    self.bgView.frame = CGRectMake(10, 120, SCREEN_WIDTH-20, 55);
    self.bgView.layer.cornerRadius = 28;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;

    _yyView = [[UIView alloc]initWithFrame:CGRectMake(10, self.bgView.frame.origin.y+self.bgView.frame.size.height+30,SCREEN_WIDTH-20, SCREEN_HEIGHT-(self.bgView.frame.origin.y+self.bgView.frame.size.height+30)-95-30)];
    [self.view addSubview:_yyView];


    _yuYueView = [[[NSBundle bundleForClass:[self class]]loadNibNamed:@"TRZBookingView" owner:self options:nil] objectAtIndex:0];
    _yuYueView.frame = CGRectMake(0, 0,_yyView.frame.size.width, SCREEN_HEIGHT-(self.bgView.frame.origin.y+self.bgView.frame.size.height+30)-95-30);
    _yuYueView.layer.cornerRadius = 10;
    _yuYueView.layer.borderWidth = 1;
    _yuYueView.layer.masksToBounds = YES;
    _yuYueView.layer.borderColor = [UIColor whiteColor].CGColor;
    _yuYueView.myTextView.delegate = self;
    [_yyView addSubview:_yuYueView];




    if ([_YuYueType isEqualToString:@"我的问题"]){
        _yuYueView.myTextTitle.text = @"告诉专家你要请教的问题(30-300字)";
        _yuYueView.myTextView.text = _problem;
        self.tishiLabel.text = @"详细描述问题有助于专家有的放失";
        self.label2.text = @"您填写的只有专家能看到，不会公开给其他人";

    }else if ([_YuYueType isEqualToString:@"自我介绍"]){
        _yuYueView.myTextTitle.text = @"介绍自己当前的情况(30-300字)";
        _yuYueView.myTextView.text = _myIntroduce;
        self.tishiLabel.text = @"详细介绍能让专家了解你";
        self.label2.text = @"您填写的只有专家能看到，不会公开给其他人";
        [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];

    }


    _yuYueView.dLabel.text = [NSString stringWithFormat:@"%lu字",300-_yuYueView.myTextView.text.length];


    if ([_yuYueView.myTextView.text length] == 0) {
        [_yuYueView.bgTextLabel setHidden:NO];
    }else{
        [_yuYueView.bgTextLabel setHidden:YES];
    }
    self.attentionBgView.layer.cornerRadius = 18;
    self.attentionBgView.layer.borderWidth = 1;
    self.attentionBgView.layer.masksToBounds = YES;
    self.attentionBgView.layer.borderColor = xiandeColor.CGColor;


    self.titleLabel.text = _ostlistModel.topicTitle;
    if (_ostlistModel.vipOnce != nil) {
        _ciLabel.text = [NSString stringWithFormat:@"  %.2f元/次  ",_ostlistModel.vipOnce.floatValue] ;
    }else{
        _ciLabel.text = [NSString stringWithFormat:@"%@元/次",_ostlistModel.muchOnce];
    }
    _timeLabel.text = [NSString stringWithFormat:@"约%@",_ostlistModel.timeOnce];
    self.attentionBgView.frame = CGRectMake(10, SCREEN_HEIGHT-48-37-10, SCREEN_WIDTH-20, 37);
    self.nextBtn.frame = CGRectMake(0, SCREEN_HEIGHT-48, SCREEN_WIDTH, 48);


    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(resignResponder)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
    
    
    [_yuYueView addGestureRecognizer:swipe];

}

-(void)resignResponder{

    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [_yuYueView.bgTextLabel setHidden:NO];
    }else{
        [_yuYueView.bgTextLabel setHidden:YES];
    }
    NSInteger count = 300;
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
    
    _yuYueView.dLabel.text  = [NSString stringWithFormat:@"%lu字",(count-textView.text.length)];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    [UIView animateWithDuration:0.3f animations:^{
            _yyView.frame = CGRectMake(10, 75,SCREEN_WIDTH-20, SCREEN_HEIGHT-(self.bgView.frame.origin.y+self.bgView.frame.size.height+30)-95-50);

    } completion:^(BOOL finished) {
    }];

}

- (void)textViewDidEndEditing:(UITextView *)textView {


    _yyView.frame = CGRectMake(10, self.bgView.frame.origin.y+self.bgView.frame.size.height+30,SCREEN_WIDTH-20, SCREEN_HEIGHT-(self.bgView.frame.origin.y+self.bgView.frame.size.height+30)-95-30);

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



- (IBAction)okBtn:(UIButton *)sender {
    
    if ([_YuYueType isEqualToString:@"我的问题"]){


            NSString *strText = [_yuYueView.myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (strText.length<30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"我的问题不能少于30个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                alert.tag = 1000;
                [alert show];
                return;
            }

        YuYueViewController *oneToOneDetails = [[YuYueViewController alloc]initWithNibName:nil bundle:nil];
        oneToOneDetails.teacherId = _teacherId;
        oneToOneDetails.topicId = _topicId;
        oneToOneDetails.problem = _yuYueView.myTextView.text;
        oneToOneDetails.myIntroduce = _myIntroduce;

        oneToOneDetails.YuYueType = @"自我介绍";
        oneToOneDetails.ostlistModel = _ostlistModel;
        oneToOneDetails.mentId = _mentId;
        oneToOneDetails.superType = _superType;
        [self.navigationController pushViewController:oneToOneDetails animated:true];


    }else if ([_YuYueType isEqualToString:@"自我介绍"]){

        NSString *strText = _yuYueView.myTextView.text;
        if (strText.length<30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"自我介绍不能少于30个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            alert.tag = 1000;
            [alert show];
            return;
        }

        [self requestOtoSchoolMeet_Api];

    }
   
}


#pragma mark -

- (void)requestOtoSchoolMeet_Api
{
    _nextBtn.userInteractionEnabled = NO;
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolMeet_Api",
                             @"apiType":@"saveMeetInfo",
                             @"problem":_problem?_problem:@"",
                             @"myIntroduce":_yuYueView.myTextView.text?_yuYueView.myTextView.text:@"",
                             @"teacherId":_teacherId?_teacherId:@"",
                             @"topicId":_topicId?_topicId:@""
                             };
    if (_mentId!=nil) {
        params = @{
                   @"requestType":@"OtoSchoolMeet_Api",
                   @"apiType":@"saveMeetInfo",
                   @"problem":_problem?_problem:@"",
                   @"myIntroduce":_yuYueView.myTextView.text?_yuYueView.myTextView.text:@"",
                   @"teacherId":_teacherId?_teacherId:@"",
                   @"topicId":_topicId?_topicId:@"",
                   @"id":_mentId?_mentId:@""
                   };
    }
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
        _nextBtn.userInteractionEnabled = YES;
        
        if ([responseObj[@"status_code"] isEqualToString:@"200"]){
            conventionId = responseObj[@"id"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:@"您可以随时在[我的专家]中查看预约进展" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
            alert.tag = 1001;
            [alert show];
            
        }
    }];
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag==1001){
        LoadCountersignController *loadController = [[LoadCountersignController alloc] init];
        loadController.superType = _superType;
        loadController.conventionId = conventionId;
        [self.navigationController pushViewController:loadController animated:YES];

    }
}
@end
