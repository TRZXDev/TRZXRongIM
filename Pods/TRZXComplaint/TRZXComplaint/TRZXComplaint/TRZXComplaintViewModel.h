//
//  TRZXComplaintViewModel.h
//  TRZXComplaint
//
//  Created by Rhino on 2017/3/2.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRZXComplaintViewModel : NSObject


+ (void)getComplaint_ApiReason:(NSString *)reason beComplaintId:(NSString *)beComplaintId imageArray:(NSArray *)imageArray Success:(void (^)(id))success failure:(void (^)(NSError *))failure;


@end
