//
//  UIImage+RCImage.m
//  RCloudMessage
//
//  Created by Liv on 15/4/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "UIImage+RCImage.h"
#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@implementation UIImage (RCImage)

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

//压缩图片至500k以下
-(NSData *)RC_dataCompress{
    NSData *data=UIImageJPEGRepresentation(self, 1.0);
    
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(self, 0.5);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(self, 1.0);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(self, 1.0);
        }
    }
    
    return data;
}

///  改变图像的尺寸，方便上传服务器
///  @param size 需要改变尺寸大小
///  @return 返回处理结果
-(UIImage *)RC_scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    //    UIGraphicsBeginImageContext(size);
    [self drawInRect:(CGRect){0,0,size}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 图片指定size 进行比例缩放
 
 @param size 目标size
 
 @return 返回截取结果 image
 */
-(UIImage *)RC_imageCompressToTagetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWith = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetWidth / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWith = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWith) * 0.5;
        }
    }
    
    //打开图片上下文
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWith;
    thumbnailRect.size.height = scaledHeight;
    //用计算好的 rect 进行图片裁剪
    [self drawInRect:thumbnailRect];
    //获取 当前截取好的上下文
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 获取bundle中图片名称
 
 @param imageName 图片名称
 
 @return 返回image
 */
+(UIImage *)RC_BundleImgName:(NSString *)imageName{

    NSString *pathStr = nil ;
    pathStr = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathStr]) {
        UIImage *image = [UIImage imageWithContentsOfFile:pathStr];
        // 2x
        return [[UIImage alloc] initWithCGImage:[image CGImage] scale:2.0f orientation:UIImageOrientationUp];
    }else{// 如果没有找到
        return [RCKitUtility imageNamed:imageName ofBundle:@"TRZXRongIM.bundle"];
    }

    return nil;
}

//- (UIImage *) allocImageByImgName:(NSString *)imageName {
//    NSString *pathStr = nil;
//    pathStr = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:pathStr]) {
//        UIImage *image = [UIImage imageWithContentsOfFile:pathStr];
//        return [[UIImage alloc] initWithCGImage:[image CGImage] scale:2.0f orientation:UIImageOrientationUp];
//    }else {
//        pathStr = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:pathStr]) {
//            return [[UIImage alloc] initWithContentsOfFile:pathStr];
//        }else {
//            return nil;
//        }
//    }
//}

@end
