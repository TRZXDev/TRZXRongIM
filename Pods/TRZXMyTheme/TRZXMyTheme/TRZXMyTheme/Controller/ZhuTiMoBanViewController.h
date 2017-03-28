//
//  ZhuTiMoBanViewController.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol zhutiBackDelegate <NSObject>
- (void)pushZhuTiBack:(NSString *)anliStr;;
@end
/**
 *  主题模板
 */

@interface ZhuTiMoBanViewController : UIViewController
@property (nonatomic, weak) id<zhutiBackDelegate>delegate;
@end
