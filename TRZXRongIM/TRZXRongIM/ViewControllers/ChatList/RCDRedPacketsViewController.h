//
//  RCDRedPacketsViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface RCDRedPacketsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UILabel *moneyPropmtLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

/*!
 会话类型
 */
@property(nonatomic, assign) RCConversationType conversationType;

@property(nonatomic, copy) NSString *targetId;


@end
