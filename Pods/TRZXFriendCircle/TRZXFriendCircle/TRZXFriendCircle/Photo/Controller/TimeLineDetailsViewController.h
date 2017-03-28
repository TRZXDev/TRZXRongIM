//
//  TimeLineDetailsViewController.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTimeModel.h"
/**
 *  相册详情
 */
@interface TimeLineDetailsViewController : UIViewController

@property (nonatomic,copy) void(^deleteTimeLineDetails)(NSString*);


@property (nonatomic,strong) PhotoTimeModel *model;
@property (nonatomic,strong) NSArray *photoTimeArray;

@end
