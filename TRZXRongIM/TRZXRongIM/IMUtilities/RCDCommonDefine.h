//
//  RCDCommonDefine.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/19.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef RCloudMessage_RCDCommonDefine_h
#define RCloudMessage_RCDCommonDefine_h


#endif
#define DEFAULTS [NSUserDefaults standardUserDefaults]
#define ShareApplicationDelegate [[UIApplication sharedApplication] delegate]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RC_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define RC_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define RCD_self __weak __typeof(self) sfself = self

// Pod 第三方导入
#import <ReactiveCocoa/UIAlertView+RACSignalSupport.h>
#import <ReactiveCocoa/RACSignal.h>
#import <Masonry/Masonry.h>
#import <Masonry/Masonry.h>
#import <TRZXKit/UIColor+APP.h>
#import <TRZXKit/UIView+TRZX.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <TRZXLogin/Login.h>
#import <TRZXNetwork/TRZXNetwork.h>
#import <RongIMKit/RongIMKit.h>
#import <TRZXPersonalJump/CTMediator+TRZXPersonalHome.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import <TRZXShare/TRZXShareManager.h>
#import <TRZXKit/UIColor+APP.h>
#import <TRZXKit/UIView+TRZX.h>
#import <TRZXInvestorDetailCategory/CTMediator+TRZXInvestorDetailCategory.h>
// 测试注释
//#import <TRZXWebViewCategory/CTMediator+TRZXWebView.h>
//#import <TRZXProjectDetailCategory/CTMediator+TRZXProjectDetail.h>
#import <TRZXMSSBrowse/MSSBrowseDefine.h>
#import <TRZXComplaint/CTMediator+TRZXComplaint.h>
#import <TRZXFriendCircle/CTMediator+TRZXFriendCircle.h>

// 分类导入
#import "UIButton+RCExtension.h"
#import "UIView+RCExtension.h"
#import "UIColor+RCColor.h"
#import "UIView+RCExtension.h"
#import "UILabel+RCExtension.h"
#import "UIBarButtonItem+RCExtension.h"
#import "UISearchBar+RCExtension.h"
#import "UIImage+RCImage.h"
#import "NSString+RCExtension.h"
#import "UIImageView+RCExtension.h"
#import "UIDevice+RCExtension.h"
#import "KPTableViewDataSource.h"
#import "RCDUtilities.h"


// 私信使用图片框架
#import "AJPhotoPickerViewController.h"
#import "AJPhotoBrowserViewController.h"


