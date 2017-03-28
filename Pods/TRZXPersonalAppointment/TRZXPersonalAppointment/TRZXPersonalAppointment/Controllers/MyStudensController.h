//
//  MyStudensController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/12.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StudenCancelController;
@class PleaseReceiveController;


@protocol MyView2Deledate <NSObject>

- (void)changeState;

@end
/**
 *  我的学员
 */
@interface MyStudensController : UIViewController
@property (strong, nonatomic)StudenCancelController *StudenCancelVC;

@property (strong, nonatomic)PleaseReceiveController *PleaseReceiveVC;

@property (strong, nonatomic)NSString *backStr;


@property (weak, nonatomic) id<MyView2Deledate>deledate;
@end
