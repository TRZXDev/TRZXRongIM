//
//  TRZXPersonalProfileViewController.h
//  TRZXPersonalProfile
//
//  Created by Rhino on 2017/3/1.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXProfileUserModel.h"

@interface TRZXPersonalProfileViewController : UIViewController

//预留
@property (copy,   nonatomic) NSString *titleStr;
//教育经历
@property (strong, nonatomic) NSArray *eduArray;
//工作经历
@property (strong, nonatomic) NSArray *workArray;
//个人简介
@property (copy,   nonatomic) NSString *abstractz;
//用户类型
@property (copy,   nonatomic) NSString *userType;

@end
