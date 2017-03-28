//
//  RCDPersonDetailViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/9.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDPersonDetailViewController.h"
#import "RCDChatViewController.h"
#import <RongIMLib/RCUserInfo.h>
#import "RCDHttpTool.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"
#import "UIBarButtonItem+RCExtension.h"
#import "UIView+RCExtension.h"
#import "UIImageView+WebCache.h"
#import "UIButton+RCExtension.h"
#import <Masonry/Masonry.h>
#import <TRZXKit/UIColor+APP.h>

@interface RCDPersonDetailViewController ()<UIActionSheetDelegate>
@property (strong, nonatomic)  UIButton *addFriendButton;
@property (strong, nonatomic)  UIButton *pushChat;
@property (nonatomic)BOOL inBlackList;
@end

@implementation RCDPersonDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    self.lblName.text = self.userInfo.name;
    NSString *company = @"";
    if(self.userInfo.company.length && self.userInfo.position.length){
        company = [NSString stringWithFormat:@"%@ , %@",self.userInfo.company,self.userInfo.position];
    }
    self.company.text = company;
    self.ivAva.RC_cornerRadius = 6;
    [self.ivAva sd_setImageWithURL:[NSURL URLWithString:self.userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    
    // 身份判断
//    if ([KPOUserDefaults currentSessionUserTypeIsOperator] && ![self.userInfo.userType isEqualToString:@"Proxy"]) {//运营商
//        self.addFriendButton.hidden = YES;
//        self.pushChat.hidden = YES;
//    }else if([KPOUserDefaults currentSessionUserTypeIsShare] && ([self.userInfo.userType isEqualToString:@"Expert"]||[self.userInfo.userType isEqualToString:@"ExpertProxy"])){//股东和专家
//        [self moreChat];
//    }else if([KPOUserDefaults currentSessionUserTypeIsExpert] && ([self.userInfo.userType isEqualToString:@"Share"]||[self.userInfo.userType isEqualToString:@"ShareProxy"])){//专家和股东
//        [self moreChat];
//    }else if([KPOUserDefaults currentSessionUserTypeIsOrgInvestor] && ([self.userInfo.userType isEqualToString:@"Share"]||[self.userInfo.userType isEqualToString:@"ShareProxy"])){//投资人和股东
//        [self moreChat];
//    }else if([KPOUserDefaults currentSessionUserTypeIsShare] && ([self.userInfo.userType isEqualToString:@"OrgInvestor"]||[self.userInfo.userType isEqualToString:@"OrgInvestorProxy"])){//股东和投资人
//        [self moreChat];
//    }else{
//        if ([self.userInfo.isAlso isEqualToString:@"Complete"]) {//是好友
//            [self pushChat];
//        }else{
//            [self addFriendButton];
//        }
//    }
}

-(void)moreChat{
    if ([self.userInfo.isAlso isEqualToString:@"Complete"]) {//是好友
        [self pushChat];
    }
//    else if([self.userInfo.isAlso isEqualToString:@"OtherSideApply"]){
//        [self.addFriendButton setTitle:@"通过验证" forState:UIControlStateNormal];
//    }
    else{
        [self addFriendButton];
        [self pushChat];
    }
    
}

#pragma mark - Properties
-(UIButton *)pushChat{
    if (!_pushChat) {
        _pushChat = [UIButton RC_buttonWithTitle:@"私聊" color:[UIColor trzx_TextColor] imageName:nil target:self action:@selector(btnConversation:)];
        _pushChat.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _pushChat.backgroundColor = [UIColor whiteColor];
        _pushChat.RC_cornerRadius = 6;
        _pushChat.RC_borderColor = [UIColor trzx_LineColor];
        _pushChat.RC_borderWidth = 1;
        [self.view addSubview:_pushChat];
        [_pushChat mas_makeConstraints:^(MASConstraintMaker *make) {
            _addFriendButton?make.top.equalTo(_addFriendButton.mas_bottom).offset(20):make.top.equalTo(self.PersonalView.mas_bottom).offset(35);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.offset(41);
        }];
    }
    return _pushChat;
}

-(UIButton *)addFriendButton{
    if (!_addFriendButton) {
        _addFriendButton = [UIButton RC_buttonWithTitle:@"加为好友" color:[UIColor whiteColor] imageName:nil target:self action:@selector(addFriendButtonDidClick:)];
        _addFriendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _addFriendButton.backgroundColor = [UIColor trzx_YellowColor];
        _addFriendButton.RC_cornerRadius = 6;
        [self.view addSubview:_addFriendButton];
        [_addFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.PersonalView.mas_bottom).offset(35);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.offset(41);
        }];
    }
    return _addFriendButton;
}

#pragma mark - Action
- (IBAction)buttonDidClick:(id)sender {
    if (self.userInfo.userId != [Login curLoginUser].userId) {
        UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:self.userInfo.userId];
        if (personalHomeVC) {
            [self.navigationController pushViewController:personalHomeVC animated:YES];
        }
    }
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnConversation:(UIButton *)button{
    
    if ([self.userInfo.userId isEqualToString:[Login curLoginUser].userId]) {
        // 融云提示
//        [LCProgressHUD showInfoMsg:@"不能和自己聊天"];
        return;
    }
    
    
    //创建会话
    RCDChatViewController *chatViewController = [[RCDChatViewController alloc] init];
    chatViewController.conversationType = ConversationType_PRIVATE;
    chatViewController.targetId = self.userInfo.userId;
    chatViewController.title = self.userInfo.name;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (void)addFriendButtonDidClick:(UIButton *)button{
    
    if([self.userInfo.isAlso isEqualToString:@"OtherSideApply"]){
        
        [[RCDHttpTool shareInstance] processRequestFriend:self.userInfo.friendRelationshipId complete:^(BOOL result) {
            button.userInteractionEnabled = YES;
            if (result) {
                button.selected = YES;
                [[RCDataBaseManager shareInstance] deleteAddFriendMessage:self.userInfo.friendRelationshipId];
                [[RCDataBaseManager shareInstance] insertFriendToDB:self.userInfo];
                
                // 融云提示
//                [LCProgressHUD showSuccess:@"验证发送成功"];   // 显示成功
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
        return ;
    }
    
    // 身份判断
//    if([self.userInfo.userId isEqualToString:[Login curLoginUser].userId]){
//        [LCProgressHUD showInfoMsg:@"不能添加自己为好友"];
//        return;
//    }
    
//    if ([[RCDataBaseManager shareInstance] getFriendByUserId:self.userInfo.userId]) {
//        [LCProgressHUD showInfoMsg:@"你与对方已是好友"];
//        return;
//    }
    
    //语音通话 暂时取消
//    [[RCIM sharedRCIM] startVoIPCallWithTargetId:self.userInfo.userId];
    if (button.selected) {
        return;
    }
    button.selected = YES;
    
    //添加好友
    [[RCDHttpTool shareInstance] requestFriend:self.userInfo.userId complete:^(BOOL result) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.selected = NO;
//                融云提示
//                [LCProgressHUD showSuccess:@"验证发送成功"];   // 显示成功
                [[RCDataBaseManager shareInstance] deleteAddFriendMessage:self.userInfo.friendRelationshipId];
//                [[RCDataBaseManager shareInstance] deleteAddFriendMessage:self.userInfo.userId];
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    }];
}

#pragma mark - 弹出 alertView
//  弹出 alertView
- (void)alertViewStr:(NSString *)str1 with:(NSString *)str2 {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:str2 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void) rightBarButtonItemClicked:(id) sender{

    if (self.inBlackList) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除好友关系", @"取消黑名单", nil];
        [actionSheet showInView:self.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"解除好友关系", @"加入黑名单", nil];
        [actionSheet showInView:self.view];
    }
}


#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //解除好友关系
            [RCDHTTPTOOL deleteFriend:self.userInfo.userId complete:^(BOOL result) {
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"删除好友成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                , nil];
                [alertView show];
            }];

        }
            break;
        case 1:{
//            MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            
            //黑名单
            __weak RCDPersonDetailViewController *weakSelf = self;
            if (!self.inBlackList) {
//                hud.labelText = @"正在加入黑名单";
//                融云提示
//                [LCProgressHUD showLoading:@"正在加入黑名单"];
                [[RCIMClient sharedRCIMClient] addToBlacklist:self.userInfo.userId success:^{
                    weakSelf.inBlackList = YES;
//                    融云提示
//                    [LCProgressHUD hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    [[RCDataBaseManager shareInstance] insertBlackListToDB:weakSelf.userInfo];

                } error:^(RCErrorCode status) {
//                    融云提示
//                    [LCProgressHUD hide];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"加入黑名单失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                                                  , nil];
                        [alertView show];
                    });
                    
                    weakSelf.inBlackList = NO;
                }];
            } else {
//                融云提示
//                [LCProgressHUD showLoading:@"正在从黑名单移除"];
                [[RCIMClient sharedRCIMClient] removeFromBlacklist:self.userInfo.userId success:^{
//                    融云提示
//                    [LCProgressHUD hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                    });
                    [[RCDataBaseManager shareInstance] removeBlackList:weakSelf.userInfo.userId];

                    weakSelf.inBlackList = NO;
                } error:^(RCErrorCode status) {
//                    融云提示
//                    [LCProgressHUD hide];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"从黑名单移除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil
                                                  , nil];
                        [alertView show];
                    });
                    
                    weakSelf.inBlackList = YES;
                }];
            }
        }
            break;
    }
}

@end
