//
//  UIImageView+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/23.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UIImageView+RCExtension.h"
#import "UIImageView+WebCache.h"
#import "UIView+RCExtension.h"
#import "RCDCommonDefine.h"

@implementation UIImageView (RCExtension)

///  UIImageView 快速构造函数
+(instancetype)RC_imageViewWithImageName:(NSString *)imageName{
    return [[UIImageView alloc]initWithImage:[UIImage RC_BundleImgName:imageName]];
}


//// 设置头像 url
+(instancetype)RC_iconViewWithImaegURl:(NSString *)imageURL placeholderImage:(NSString *)placeholderImage{
    
    UIImageView *image = [[UIImageView alloc]init];
    
    [image sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage RC_BundleImgName:placeholderImage]];
    image.RC_cornerRadius = 6;
    
    return image;
    
}

@end
