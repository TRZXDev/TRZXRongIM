//
//  CTMediator+TRZXConfirmFinancing.h
//  TRZXConfirmFinancingBusinessCategory
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>
typedef void(^confirmCompleteBlock)(NSString *trade,NSString *stage);

@interface CTMediator (TRZXProjectScreening)
- (UIViewController *)projectScreeningViewControllerWithScreeningType:(NSString *)screeningType projectTitle:(NSString *)projectTitle confirmComplete:(confirmCompleteBlock)confirmComplete;

@end
