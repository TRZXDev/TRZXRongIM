//
//  RCDUtilities.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/7/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

static NSString* RCD_BPViewShowKey = @"RCD_BPViewShowKey";

/**
 工具类
 */
@interface RCDUtilities : NSObject

+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName;

+ (void)setRCD_BPViewShow:(BOOL)isShow;

+ (BOOL)RCD_BPViewShow;

@end
