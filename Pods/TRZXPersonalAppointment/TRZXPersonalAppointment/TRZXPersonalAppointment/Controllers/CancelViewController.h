//
//  CancelViewController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancelViewController : UIViewController

{
    UITableView *myTableView;
    NSArray *dataArr;
}
@property (strong, nonatomic) NSString *conventionId;
@property (strong, nonatomic) NSString *qxReason;
@property (assign, nonatomic) NSInteger meetStase;


@property(nonatomic,copy)void (^removePushVCBlock)();

@end
