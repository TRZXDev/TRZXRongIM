//
//  RCDUpdateNameViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDUpdateNameViewController.h"
#import "RCDHttpTool.h"
#import <RongIMLib/RongIMLib.h>
#import "UIColor+RCColor.h"
#import "RCDCommonDefine.h"

@interface RCDUpdateNameViewController()<UITextFieldDelegate>

@end

@implementation RCDUpdateNameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"0195ff" alpha:1.0f]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor trzx_YellowColor]];
    
    self.tfName.text = self.displayText;
    
//    self.tfName.delegate = self;
    [self.tfName addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventAllEditingEvents];
    self.tfName.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) backBarButtonItemClicked:(id) sender{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) rightBarButtonItemClicked:(id) sender{
    
    if(self.tfName.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入群名称!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([self.tfName.text hasSuffix:@" "]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"群名称开头不能单独用空格表示!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    if([self.tfName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"群名称不能单独用空格表示!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [[RCDHttpTool shareInstance] setGroupName:self.tfName.text groupId:self.targetId complete:^(BOOL result) {
        //回传值
        if (self.setDisplayTextCompletion) {
            self.setDisplayTextCompletion(self.tfName.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //收起键盘
    [self.tfName resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.0f;
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([NSString RC_isInputRuleNotBlank:string]){
        return YES;
    }
    if([string RC_isContainsEmoji]){
        return NO;
    }
    if([string RC_utf8Length]){
        return NO;
    }
    
    return YES;
}

- (void)textChanged:(UITextField *)textField{

    NSInteger stringLength = 20;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > stringLength) {
                toBeString = [toBeString substringToIndex:stringLength];
            }
        }else{ // 有高亮选择的字符串，则暂不对文字进行统计和限制
            return;
        }
    }else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > stringLength) {
            toBeString = [toBeString substringToIndex:stringLength];
        }
    }

    textField.text = toBeString;
}



@end
