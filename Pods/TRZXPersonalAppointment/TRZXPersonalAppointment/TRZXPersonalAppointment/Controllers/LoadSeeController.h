//
//  LoadSeeController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CancelViewController;
@interface LoadSeeController : UIViewController


@property (strong, nonatomic)CancelViewController *cancelVC;

@property (copy, nonatomic) NSString *mid;
@property (strong, nonatomic)NSString *wodelyStr;

@end
