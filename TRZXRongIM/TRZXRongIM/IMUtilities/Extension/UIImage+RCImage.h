//
//  UIImage+RCImage.h
//  RCloudMessage
//
//  Created by Liv on 15/4/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RCImage)

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;


///  压缩图片至500k以下
///  @return 压缩完成二进制
-(NSData *)RC_dataCompress;


///  改变图像的尺寸，方便上传服务器
///  @param size 需要改变尺寸大小
///  @return 返回处理结果
-(UIImage *)RC_scaleToSize:(CGSize)size;

/**
 图片指定size 进行比例缩放
 
 @param size 目标size
 
 @return 返回截取结果 image
 */
-(UIImage *)RC_imageCompressToTagetSize:(CGSize)size;


/**
 获取bundle中图片名称

 @param imageName 图片名称

 @return 返回image
 */
+(UIImage *)RC_BundleImgName:(NSString *)imageName;

@end
