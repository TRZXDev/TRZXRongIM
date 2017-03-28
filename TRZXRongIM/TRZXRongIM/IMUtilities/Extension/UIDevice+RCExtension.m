//
//  UIDevice+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/24.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UIDevice+RCExtension.h"

@implementation UIDevice (RCExtension)

//判断设备是否有摄像头
+(BOOL)RC_isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

@end
