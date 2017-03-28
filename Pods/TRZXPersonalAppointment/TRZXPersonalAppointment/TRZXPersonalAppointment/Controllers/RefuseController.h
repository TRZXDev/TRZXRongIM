//
//  RefuseController.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/22.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  拒绝约见
 */
@interface RefuseController : UIViewController

{
    UITableView *myTableView;
    NSArray *dataArr;
}

@property (copy, nonatomic) NSString *mid;

@property (assign, nonatomic) NSInteger meetStase;

@end
