//
//  CTMediator+TRZXFriendCircle.h
//  TRZXFriendCircle
//
//  Created by 张江威 on 2017/3/20.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

@interface CTMediator (TRZXFriendCircle)
//朋友圈
- (UIViewController *)FriendCircle_TRZXFriendLineTableViewController;
//相册
- (UIViewController *)FriendCircle_PhotoTimeLineTableViewController;

@end
