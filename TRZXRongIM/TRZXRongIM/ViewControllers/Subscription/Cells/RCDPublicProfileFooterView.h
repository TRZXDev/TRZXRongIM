//
//  RCDPublicProfileFooterView.h
//  TRZX
//
//  Created by 移动微 on 16/11/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDPublicProfileFooterView : UIView

@property(nonatomic, strong)UIButton *footerButton;


@property(nonatomic, copy) void (^footerButtonBlock)();

@end
