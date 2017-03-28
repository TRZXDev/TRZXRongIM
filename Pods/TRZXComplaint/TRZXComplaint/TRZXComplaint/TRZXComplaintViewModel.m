//
//  TRZXComplaintViewModel.m
//  TRZXComplaint
//
//  Created by Rhino on 2017/3/2.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "TRZXComplaintViewModel.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@implementation TRZXComplaintViewModel

static NSString *baseURL = @"http://api.kipo.mmwipo.com/"; //baseURL

/**
 *  投诉
 *
 *  @param reason  ..
 *  @param beComplaintId ..
 *  @param imageArray  ..
 *  @param success ..
 *  @param failure  ..
 */
+ (void)getComplaint_ApiReason:(NSString *)reason beComplaintId:(NSString *)beComplaintId imageArray:(NSArray *)imageArray Success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
//    [LCProgressHUD showLoading:@"正在上传"];   // 显示等待
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (UIImage *img  in imageArray) {
        UIImage *image = [self kipo_normalizedImage:img];//[self normalizedImage:img];
        [imageArr addObject:[self kipo_dataCompress:image]];
    }
    
    NSDictionary *param = @{
                            @"requestType":@"Complaint_Api",
                            @"reason":reason?reason:@"",
                            @"beComplaintId":beComplaintId?beComplaintId:@"",
                            };
    AFHTTPSessionManager *_manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                               @"text/html",
                                                                               @"text/json",
                                                                               @"text/plain",
                                                                               @"text/javascript",
                                                                               @"text/xml",
                                                                               @"image/*"]];
    
    [_manager POST:baseURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i<imageArr.count; i++) {
            NSData *data = imageArr[i];
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%d",i+1] fileName:[NSString stringWithFormat:@"image.png"] mimeType:@"image/*"];
        }
    } success:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject[@"status_code"] isEqualToString:@"200"]) {
    //        [LCProgressHUD showSuccess:@"上传成功"];    显示成功
        } else {
 //           [LCProgressHUD showFailure:@"上传失败"];   // 显示失败
        }
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {

   //     [LCProgressHUD showFailure:@"上传失败"];   // 显示失败
        success(error);
    }];
    
}

///处理直接拍照上传照片 图片翻转的问题
+ (UIImage *)kipo_normalizedImage:(UIImage *)image{
    if (image.imageOrientation == UIImageOrientationUp)return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0,0,image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
    
}




//压缩图片至500k以下
+ (NSData *)kipo_dataCompress:(UIImage *)image
{
    NSData *data=UIImageJPEGRepresentation(image, 1.0);
    
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(image, 1.0);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(image, 1.0);
        }
    }
    
    
    return data;
}

@end
