//
//  TRZXNetwork.h
//  TRZXNetwork
//
//  Created by N年後 on 2017/2/6.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TRZXNetwork : NSObject

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, NetworkStatus) {
    /**
     *  未知网络
     */
    NetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    NetworkStatusNotReachable        = 1 << 2,
    /**
     *  网络正常
     */
    NetworkStatusNormal              = 1 << 3
};


/**
 *  请求方式
 */
typedef enum {
    /**
     *  GET方式来进行请求
     */
    GET = 0,
    /**
     *  POST方式来进行请求
     */
    POST
} NetworkMethod;

///**
// *  请求方式
// */
//typedef NS_ENUM(NSInteger, NetworkMethod) {
//    /**
//     *  POST方式来进行请求
//     */
//    POST = 1 << 0,
//    /**
//     *  GET方式来进行请求
//     */
//    GET  = 1 << 1
//};


/**
 *  GET POST请求数据缓存方式
 */
typedef NS_ENUM(NSUInteger, NetworkingRequestCachePolicy){
    /**
     *  有缓存就先返回缓存，同步请求数据
     */
    NetworkingReturnCacheDataThenLoad       = 1 << 0,
    /**
     *  忽略缓存，重新请求
     */
    NetworkingReloadIgnoringLocalCacheData  = 1 << 2,
    /**
     *  有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
     */
    NetworkingReturnCacheDataElseLoad       = 1 << 3,
    /**
     *  有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
     */
    NetworkingReturnCacheDataDontLoad       = 1 << 4,
};



/**
 *  数据串行方式
 */
typedef NS_ENUM(NSInteger, SerializerType) {
    /**
     *  HTTP方式来进行请求或响应
     */
    HTTPSerializer = 1 << 0,
    /**
     *  JSON方式来进行请求或响应
     */
    JSONSerializer = 1 << 1
};


//=================================

/**
 *  请求任务  起个别名，你懂的
 */
typedef NSURLSessionTask URLSessionTask;

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;


/**
 *  配置请求头
 *
 *  @param httpHeaders 请求头参数
 */
+ (void)configHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *  baseURL
 *
 *  @param baseURL 参数
 */
+ (void)configWithBaseURL:(NSString *)url;


/**
 *  NewBaseURL
 *
 *  @param baseURL 参数
 */
+ (void)configWithNewBaseURL:(NSString *)url;
/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 *  更新请求或者返回数据的解析方式(0为HTTP模式，1为JSON模式)
 *
 *  @param requestType  请求数据解析方式
 *  @param responseType 返回数据解析方式
 */
+ (void)updateRequestSerializerType:(SerializerType)requestType
                 responseSerializer:(SerializerType)responseType;



/**
 *  请求回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^requestCallbackBlock)(id response,NSError *error);


/**
 *  进度
 *
 *  @param bytesRead              已下载或者上传进度的大小
 *  @param totalBytes                总下载或者上传进度的大小
 */
typedef void(^NetWorkingProgress)(int64_t bytesRead,int64_t totalBytes);





/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  根据url取消请求
 *
 *  @param url 请求url
 */
+ (void)cancelRequestWithURL:(NSString *)url;







/**
 *  统一请求接口(不带缓存)
 *
 *  @param url                  请求路径
 *  @param params               拼接参数
 *  @param method               请求方式（0为POST,1为GET）
 *  @param callbackBlock        请求回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)requestWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                            method:(NetworkMethod)method
                     callbackBlock:(requestCallbackBlock)callbackBlock;



/**
 *  统一请求接口
 *
 *  @param url                  请求路径
 *  @param params               拼接参数
 *  @param method               请求方式（0为POST,1为GET）
 *  @param cachePolicy          缓存类型
 *  @param callbackBlock        请求回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)requestWithUrl:(NSString *)url
                            params:(NSDictionary *)params
                            method:(NetworkMethod)method
                       cachePolicy:(NetworkingRequestCachePolicy)cachePolicy
                     callbackBlock:(requestCallbackBlock)callbackBlock;



/**
 *  图片上传接口
 *
 *	@param image            图片对象
 *  @param url              请求路径
 *	@param name             图片名
 *	@param type             默认为image/jpeg
 *	@param params           拼接参数
 *	@param progressBlock    上传进度
 *  @param callbackBlock    请求回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)uploadWithImage:(UIImage *)image
                                url:(NSString *)url
                               name:(NSString *)name
                               type:(NSString *)type
                             params:(NSDictionary *)params
                      progressBlock:(NetWorkingProgress)progressBlock
                      callbackBlock:(requestCallbackBlock)callbackBlock;

/**
 *  文件上传接口
 *
 *  @param url              上传文件接口地址
 *  @param uploadingFile    上传文件路径
 *  @param progressBlock    上传进度
 *  @param callbackBlock    请求回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (URLSessionTask *)uploadFileWithUrl:(NSString *)url
                        uploadingFile:(NSString *)uploadingFile
                        progressBlock:(NetWorkingProgress)progressBlock
                        callbackBlock:(requestCallbackBlock)callbackBlock;

/**
 *  文件下载接口
 *
 *  @param url              下载文件接口地址
 *  @param saveToPath       存储目录
 *  @param progressBlock    下载进度
 *  @param callbackBlock    请求回调
 *
 *  @return 返回的对象可取消请求
 */
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                         saveToPath:(NSString *)saveToPath
                      progressBlock:(NetWorkingProgress)progressBlock
                      callbackBlock:(requestCallbackBlock)callbackBlock;


/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progressBlock 文件下载的进度信息
 *  @param callbackBlock    请求回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (URLSessionTask *)downloadWithURL:(NSString *)URL
                            fileDir:(NSString *)fileDir
                      progressBlock:(NetWorkingProgress)progressBlock
                      callbackBlock:(requestCallbackBlock)callbackBlock;


@end
