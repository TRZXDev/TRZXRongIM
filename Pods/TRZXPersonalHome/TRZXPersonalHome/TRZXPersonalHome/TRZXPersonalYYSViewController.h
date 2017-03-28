//
//  TRZXPersonalYYSViewController.h
//  TRZX
//
//  Created by 张江威 on 16/9/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol yysDelegate <NSObject>
- (void)pushAllSetting;
@end


@interface TRZXPersonalYYSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) id<yysDelegate>delegate;


@property (nonatomic, strong) NSString * titleStr;


@end
