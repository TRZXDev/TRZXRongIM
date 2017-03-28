//
//  DynamicHomeViewController.h
//  TRZX
//
//  Created by 张江威 on 2016/10/27.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXFriendLineTableViewController.h"


@protocol NewDynamicDelegate <NSObject>
- (void)pushload;
@end


@interface DynamicHomeViewController : UITableViewController

@property (nonatomic, weak) id<NewDynamicDelegate>delegate;

@property (strong, nonatomic) NSString * otherIdStr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString * navStr;//判断导航

@property (nonatomic, strong) NSString * selfNameStr;
@property (nonatomic, strong) NSString * selfIDStr;
@property (nonatomic, strong) NSString * selfIconStr;


@end
