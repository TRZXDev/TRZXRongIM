//
//  RCDAddFriendTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDAddFriendTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"

@interface RCDAddFriendTableViewController ()

@end

@implementation RCDAddFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置默认隐藏
    [_lblAgreeTip setHidden:YES];
    _lblUserName.text = _userInfo.name;

    [_ivAva sd_setImageWithURL:[NSURL URLWithString:_userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    //根据userId获取是否好友

    [RCDHTTPTOOL isMyFriendWithUserInfo:_userInfo completion:^(BOOL isFriend) {
        if (isFriend) {
            _lblAgreeTip.hidden = NO;
            _btnAgree.hidden = YES;
            _btnDisagree.hidden = YES;

        }
    }];    
}
- (IBAction)actionAgree:(id)sender {
    if (self.userInfo.userId==nil) {
        return;
    }
}

- (IBAction)actionDisagree:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已拒绝对方好友申请！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];;
    [alertView show];
}


@end
