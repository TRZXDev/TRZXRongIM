//
//  CTMediator+TRZXConfirmFinancing.m
//  TRZXConfirmFinancingBusinessCategory
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "CTMediator+TRZXMapHome.h"

@implementation CTMediator (TRZXMapHome)
- (UIViewController *)mapHomeViewController:(NSString *)projectTitle{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"projectTitle"] = projectTitle;
    return [self performTarget:@"TRZXMapHome" action:@"MapHomeViewController" params:params shouldCacheTarget:NO];
}
@end
