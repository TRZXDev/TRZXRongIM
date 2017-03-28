//
//  RCDPublicServiceProfileViewController.h
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 公众服务账号信息的ViewController
 继承于 RCPublicServiceProfileViewController 目的 制定化扩展
 */
@interface RCDPublicServiceProfileViewController : UIViewController

/**
 公众号模型
 */
@property(nonatomic, strong) RCPublicServiceProfile *profile;

@property(nonatomic, copy) NSString *publicId;
//clearHistoryMessage
@property(nonatomic, copy) void(^clearHistoryMessage)();

@end
