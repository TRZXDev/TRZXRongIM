//
//  Target_TRZXPersonalAppointment.m
//  TRZXPersonalAppointment
//
//  Created by 张江威 on 2017/3/15.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "Target_TRZXFriendCircle.h"
#import "TRZXFriendLineTableViewController.h"
#import "PhotoTimeLineTableViewController.h"

@implementation Target_TRZXFriendCircle

//朋友圈
- (UIViewController *)Action_FriendCircle_TRZXFriendLineTableViewController:(NSDictionary *)parm{
    TRZXFriendLineTableViewController *friendViewC = [[TRZXFriendLineTableViewController alloc]init];
    return friendViewC;
}
//相册
- (UIViewController *)Action_FriendCircle_PhotoTimeLineTableViewController:(NSDictionary *)parm{
    PhotoTimeLineTableViewController *photoController = [[PhotoTimeLineTableViewController alloc]init];
    return photoController;
}

@end
