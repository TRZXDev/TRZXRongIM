//
//  SendTimeLineViewController.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  选择入口图标的类型
 */
typedef NS_ENUM(NSInteger, SendTimeLineType) {
    /**
     *  文本
     */
    SendTimeLineypeText = 1,
    /**
     *  图文 =
     */
    SendTimeLineypeImageText = 2,
    /**
     *  分享
     */
    SendTimeLineypeShare = 3

};



@interface SendTimeLineViewController : UIViewController


- (instancetype)initWithSendTimeLineype:(SendTimeLineType)type;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
//@property (nonatomic,strong) OSMessage*message;// 分享信息模型
@property (nonatomic,copy) void(^sendSuccessTimeLineBlock)(void);


@end
