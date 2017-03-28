//
//  RCDRedPacketsViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDRedPacketsViewController.h"
#import "RCDRedPacketsMessage.h"
#import "RCDCommonDefine.h"
@interface RCDRedPacketsViewController ()<UITextFieldDelegate>

@end

@implementation RCDRedPacketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor =  self.navigationController.navigationBar.backgroundColor = [UIColor trzx_RedColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_barButtonWithTitle:@"关闭" color:[UIColor trzx_YellowColor] imageName:nil target:self action:@selector(leftBarButtonPress:)];
    UILabel *leftLabel = [UILabel RC_labelWithTitle:@"金额" color:[UIColor blackColor] fontSize:15];
    self.moneyTextField.leftView = leftLabel;
    self.moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    UILabel *rightLabel = [UILabel RC_labelWithTitle:@"元" color:[UIColor blackColor] fontSize:15];
    self.moneyTextField.rightView = rightLabel;
    self.moneyTextField.rightViewMode = UITextFieldViewModeAlways;

    [self.moneyTextField addTarget:self  action:@selector(texdFieldValueChange:)  forControlEvents:UIControlEventAllEditingEvents];
    self.sendButton.selected = NO;
}



-(void)leftBarButtonPress:(UIBarButtonItem *)barButton{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [self.moneyTextField removeTarget:self action:@selector(texdFieldValueChange:) forControlEvents:UIControlEventValueChanged];
}
- (IBAction)sendButtonDidClick:(UIButton *)sender {
    
    if (sender.selected == NO)
        return ;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //发送
        RCDRedPacketsMessage *message = [RCDRedPacketsMessage messageWithTitle:self.contentTextField.text?self.contentTextField.text:self.contentTextField.placeholder content:@"领取红包"];
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:message pushContent:@"您有新的消息" pushData:@"" success:^(long messageId) {
        } error:^(RCErrorCode nErrorCode, long messageId) {
        }];
    }];

}

#pragma mark - UITextFieldDelegate
-(void)texdFieldValueChange:(UITextField *)textField{
    
    if (textField.text.floatValue>0.01) {
        [self.sendButton setBackgroundColor:[UIColor trzx_RedColor]];
        self.sendButton.selected = YES;
        self.moneyPropmtLabel.text = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
    }else{
        [self.sendButton setBackgroundColor:[UIColor colorWithRed:252/255.0 green:192/255.0 blue:188/255.0 alpha:1]];
        self.sendButton.selected = NO;
        self.moneyPropmtLabel.text = [NSString stringWithFormat:@"0.00"];
    }
}


@end
