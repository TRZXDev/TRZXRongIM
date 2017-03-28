//
//  CTMediator+TRZXConfirmFinancing.m
//  TRZXConfirmFinancingBusinessCategory
//
//  Created by N年後 on 2017/1/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "CTMediator+TRZXWebView.h"

@implementation CTMediator (TRZXWebView)
- (UIViewController *)webViewControllerWithWebURL:(NSString *)webURL
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"webURL"] = webURL;
    return [self performTarget:@"TRZXWeb" action:@"WebViewController" params:params shouldCacheTarget:NO];
}
@end
