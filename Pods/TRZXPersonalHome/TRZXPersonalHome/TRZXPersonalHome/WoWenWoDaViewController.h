//
//  WoWenWoDaViewController.h
//  TRZX
//
//  Created by 张江威 on 16/7/22.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WoWenWoDaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) NSString * midStrr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString * titleStrr;

@property (strong, nonatomic) NSString * title2Str;

@end
