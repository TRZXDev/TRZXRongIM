//
//  TRZXPersonalCareAboutController.h
//  TRZXPersonalCareAbout
//
//  Created by 张江威 on 2017/2/23.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GuanZhuDelegate <NSObject>
- (void)pushAllSetting;
@end

@interface TRZXPersonalCareAboutController : UIViewController

@property (nonatomic, weak) id<GuanZhuDelegate>delegate;


@property (strong, nonatomic) NSString * midStr;

@end
