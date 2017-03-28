//
//  ChooseTimeController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadSeeController;

@interface ChooseTimeController : UIViewController

@property (nonatomic, strong) LoadSeeController *loadSeeVC;

@property (copy, nonatomic) NSString *meetId;

@end
