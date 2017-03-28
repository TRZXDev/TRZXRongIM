//
//  CTMediator+TRZXConfirmFinancing.m
//  TRZXConfirmFinancingBusinessCategory
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "CTMediator+TRZXProjectScreening.h"

@implementation CTMediator (TRZXProjectScreening)
- (UIViewController *)projectScreeningViewControllerWithScreeningType:(NSString *)screeningType projectTitle:(NSString *)projectTitle confirmComplete:(confirmCompleteBlock)confirmComplete{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"screeningType"] = screeningType;
    params[@"projectTitle"] = projectTitle;
    params[@"completeBlock"] = confirmComplete;
    return [self performTarget:@"TRZXProjectScreening" action:@"ProjectScreeningViewController" params:params shouldCacheTarget:NO];
}
@end
