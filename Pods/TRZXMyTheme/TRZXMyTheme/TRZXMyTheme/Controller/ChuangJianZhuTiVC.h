//
//  ChuangJianZhuTiVC.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  创建主题控制器
 */
@protocol zhuti1Delegate <NSObject>
- (void)pushZhuTiDe;
@end
@interface ChuangJianZhuTiVC : UIViewController{
    
}

@property (nonatomic, copy) NSString *topic;
@property (nonatomic, copy) NSString *abstracts;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *duration;
@property (copy, nonatomic) NSString *themeID;
@property (copy, nonatomic) NSString *epId;
@property (copy, nonatomic) UILabel *themeCategory;

@property (copy, nonatomic)NSString *oneAreaId;
@property (copy, nonatomic)NSString *twoAreaId;
@property (copy, nonatomic)NSString *yuancheng;
@property (copy, nonatomic)NSString *one;
@property (copy, nonatomic)NSString *two;
@property (copy, nonatomic)NSString *themeType;
@property (copy, nonatomic)NSString *xiugaiStr;

@property (copy, nonatomic)NSString *wumobanStr;


@property (nonatomic, weak) id<zhuti1Delegate>delegate;

@end
