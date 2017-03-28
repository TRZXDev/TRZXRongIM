//
//  TRZXFriendDetailsViewController.h
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewDetailsDelegate <NSObject>
- (void)refresh;
@end

@interface TRZXFriendDetailsViewController : UITableViewController

@property (nonatomic, weak) id<NewDetailsDelegate>delegate;

@property (assign, nonatomic) NSInteger indexTeger;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString * otherIdStr;
@property (strong, nonatomic) NSString * userIdStr;

@property (strong, nonatomic) NSString * navStr;//判断导航

@property (nonatomic, strong) UIMenuItem * itemIT;
@property (nonatomic, strong) NSString *copStr;

@property (nonatomic, strong) NSString * selfNameStr;
@property (nonatomic, strong) NSString * selfIDStr;
@property (nonatomic, strong) NSString * selfIconStr;


@end
