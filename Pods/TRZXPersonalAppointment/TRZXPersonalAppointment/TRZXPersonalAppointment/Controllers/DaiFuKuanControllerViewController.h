//
//  DaiFuKuanControllerViewController.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 15/12/25.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  约见状态控制器
 */
@protocol DaifuKuanDelegate <NSObject>

- (void)changeTopVC;

@end

@interface DaiFuKuanControllerViewController : UIViewController
@property (copy, nonatomic) NSString *mid;

@property (copy, nonatomic) NSString *vCType;

@property (strong, nonatomic) NSString *vipPDStr;

@property (weak, nonatomic) id<DaifuKuanDelegate>delegate;

@end
