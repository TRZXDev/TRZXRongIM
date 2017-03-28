//
//  ComplaintsMsgViewController.h
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  举报类型
 */
typedef NS_ENUM(NSUInteger, ComplaintsSubType) {
    /**
     *  色情
     */
    ComplaintsSubType_SQ,
    /**
     *  赌博
     */
    ComplaintsSubType_DB,
    /**
     *  敏感信息
     */
    ComplaintsSubType_MGXX,
    /**
     *  欺诈
     */
    ComplaintsSubType_QZ,
    /**
     *  违法
     */
    ComplaintsSubType_WF,
};

/**
 *  投诉选择信息 图片 聊天记录
 */
@interface TRZXComplaintsMsgViewController : UIViewController

@property (nonatomic,assign)NSInteger type;

@property (nonatomic,copy)NSString *subType;

@property (nonatomic,strong)NSArray *chatMsgArray;

@property (nonatomic,copy)NSString *targetId;
@property (nonatomic,copy)NSString *userTitle;


@end
