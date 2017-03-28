//
//  PhotoTimeLineTableViewController.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhotoDelegate <NSObject>
- (void)pushAllSetting;
@end

/**
 *  相册
 */
@interface PhotoTimeLineTableViewController : UIViewController
@property (nonatomic, weak) id<PhotoDelegate>delegate;
@property (strong, nonatomic) NSString * otherIdStr;
@property (strong, nonatomic) NSString * nameStr;
@end
