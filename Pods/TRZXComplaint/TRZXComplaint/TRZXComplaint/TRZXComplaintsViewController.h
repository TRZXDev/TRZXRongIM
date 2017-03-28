//
//  ComplaintsViewController.h
//  tourongzhuanjia
//
//  Created by Rhino on 16/5/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ComplaintsType) {
    ComplaintsType_None,
    ComplaintsType_Setting,//设置
    ComplaintsType_Chat,//私信
};
/**
 *  投诉
 */
@interface TRZXComplaintsViewController : UIViewController


@property (nonatomic,assign)ComplaintsType type;
@property (nonatomic,copy)NSString *targetId;//被投诉人UserID
@property (nonatomic,copy)NSString *userTitle;

@end
