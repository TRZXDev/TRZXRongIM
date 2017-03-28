//
//  UIImageView+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/23.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (RCExtension)

///  UIImageView 快速构造函数
///  @param imageName 图片名
///  @return  UIImageView
+(instancetype)RC_imageViewWithImageName:(NSString *)imageName;

//// 设置头像 url
///  @param imageURL 头像 的url 字符串
///  @param placeholderImage 头像 占位符
///  @return  UIImageView
+(instancetype)RC_iconViewWithImaegURl:(NSString *)imageURL placeholderImage:(NSString *)placeholderImage;

@end
