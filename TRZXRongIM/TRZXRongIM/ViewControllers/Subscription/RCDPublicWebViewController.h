//
//  RCDPublicWebViewController.h
//  TRZX
//
//  Created by 移动微 on 17/1/8.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

/**
 公众号网页控制器
 */
@interface RCDPublicWebViewController : UIViewController

/**
 必传
 */
@property(nonatomic, copy) NSString *webURL;

@property (nonatomic, strong) RCPublicServiceProfile *profile;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *headURL;
@end
