//
//  TRZXPersonalWatchController.h
//  TRZXPersonalWatch
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuanKanDelegate <NSObject>
- (void)pushAllSetting;
@end

@interface TRZXPersonalWatchController : UIViewController

@property (nonatomic, weak) id<GuanKanDelegate>delegate;

@property (strong, nonatomic) NSString * panduanStr;

@property (strong, nonatomic)NSString *midStr;

@end
