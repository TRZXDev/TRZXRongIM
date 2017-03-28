//
//  UIView+RCExtension.h
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RCExtension)

@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;


///  快熟构造 view 背景颜色
///  @return UIView
+(instancetype)RC_viewWithColor:(UIColor *)color;
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *RC_borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat RC_borderWidth;
/// 脚半径
@property (nonatomic, assign) IBInspectable CGFloat RC_cornerRadius;

-(UIImage *)RC_convertViewToImage;

- (void)RC_removeAllSubviews;

@end
