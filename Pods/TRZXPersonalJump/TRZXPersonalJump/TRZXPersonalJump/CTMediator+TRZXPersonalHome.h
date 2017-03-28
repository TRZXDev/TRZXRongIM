//
//  CTMediator+TRZXPersonalHome.h
//  TRZXPersonalJump
//
//  Created by 张江威 on 2017/2/27.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

@interface CTMediator (TRZXPersonalHome)
- (UIViewController *)personalHomeViewControllerWithOtherStr:(NSString *)otherStr midStrr:(NSString *)midStrr;
//我的收藏
- (UIViewController *)CollectionViewController;

@end
