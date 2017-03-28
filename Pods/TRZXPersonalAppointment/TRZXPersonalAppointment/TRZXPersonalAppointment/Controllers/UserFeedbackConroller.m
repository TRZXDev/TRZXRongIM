//
//  UserFeedbackConroller.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "UserFeedbackConroller.h"
#import "TRZXPersonalAppointmentPch.h"


@interface UserFeedbackConroller ()<UITextFieldDelegate, UITextViewDelegate>

{
    UITextField *emaileText;
    UITextView *textView1;
}

@end

@implementation UserFeedbackConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户反馈";
    [self createUI];
    self.view.backgroundColor = backColor;
}

- (void)createUI {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(74);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(45));
    }];
    
    emaileText = [[UITextField alloc] init];
    emaileText.placeholder = @"邮箱";
    emaileText.keyboardType = UIKeyboardTypeEmailAddress;
    emaileText.font = [UIFont systemFontOfSize:15];
    emaileText.delegate = self;
    [topView addSubview:emaileText];
    [emaileText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(10);
        make.left.equalTo(topView.mas_left).offset(8);
        make.right.equalTo(topView.mas_right).offset(-8);
        make.height.equalTo(@(25));
    }];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.text = @"请输入您的意见和建议,我们将不断为您改进";
    lable1.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:lable1];
    
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(124);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(20));
    }];
    
    textView1 = [[UITextView alloc] init];
    textView1.layer.cornerRadius = 10;
    textView1.delegate = self;
    [self.view addSubview:textView1];
    
    [textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(150);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(150));
    }];
    
    UIButton *tiJiaoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [tiJiaoButton setTitle:@"反馈提交" forState:UIControlStateNormal];
    
    [tiJiaoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tiJiaoButton addTarget:self action:@selector(tijiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tiJiaoButton setBackgroundColor:TRZXMainColor];
    tiJiaoButton.layer.cornerRadius = 10;
    tiJiaoButton.layer.masksToBounds = YES;
    [self.view addSubview:tiJiaoButton];
    [tiJiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(320);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(45));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"或工作日拨打我们的客服电话";
    label2.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-95);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(20));
    }];
    
    UIButton *PhoneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [PhoneBtn setTitle:@"0138-2345678" forState:UIControlStateNormal];
    [PhoneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PhoneBtn setBackgroundColor:[UIColor whiteColor]];
    [PhoneBtn addTarget:self action:@selector(phoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:PhoneBtn];
    
    [PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(45));
    }];
}

- (void)goBackView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tijiaoBtn:(UIButton *)sender
{
    if (emaileText.text.length == 0) {
//        [LCProgressHUD showInfoMsg:@"请输入邮箱"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入邮箱" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        if ([TRZXPersonalAppointmentPch isValidateEmail:emaileText.text]) {
            if (textView1.text.length == 0) {
//                [LCProgressHUD showInfoMsg:@"输入意见不能为空"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入意见不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            } else {
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSString *trimedString = [textView1.text stringByTrimmingCharactersInSet:set];
                if ([trimedString length] == 0) {
//                    [LCProgressHUD showInfoMsg:@"请正确输入意见"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请正确输入意见" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                } else {
                    [emaileText resignFirstResponder];
                    [textView1 resignFirstResponder];
                    [self tijiao_Api];
                }
                
                
            }
        } else {
//            [LCProgressHUD showInfoMsg:@"请输入正确的邮箱"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的邮箱" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    
    }
}

- (void)tijiao_Api {
    NSDictionary *params = @{
                             @"requestType":@"OtoSchoolUserFb_Api",
                             @"apiType":@"saveFeedback",
                             @"email":emaileText.text?emaileText.text:@"",
                             @"content":textView1.text?textView1.text:@""
                             };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
            if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (void)phoneBtn:(UIButton *)sender
{
    [self alertViewStr:@"拨打电话" and:@"0138-2345678"];
}

//警告框
- (void)alertViewStr:(NSString *)str1 and:(NSString *)str2 {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果有多个alertView，需要通过tag值区分
    
    //一个警告框里通过buttonIndex来区分点击的是哪个按钮
    if (buttonIndex == 0) {
//        TRZXLog(@"取消按钮被点击");
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"01382345678"]]];
    }
}



- (void)createKeyBoard {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)keyboardShow {
    self.view.frame = CGRectMake(0, -50, WIDTH(self.view), HEIGTH(self.view));
    
}
- (void)keyboardHide {
    self.view.frame = CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view));
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    
    
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
