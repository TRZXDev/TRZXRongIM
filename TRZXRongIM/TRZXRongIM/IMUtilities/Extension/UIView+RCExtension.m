//
//  UIView+RCExtension.m
//  RongIM_Test
//
//  Created by 移动微 on 17/2/22.
//  Copyright © 2017年 移动微. All rights reserved.
//

#import "UIView+RCExtension.h"

@implementation UIView (RCExtension)

-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(CGFloat)y{
    return self.frame.origin.y;
}

///  快熟构造 view 使用颜色
+(instancetype)RC_viewWithColor:(UIColor *)color{
    
    UIView *view =[[UIView alloc]init];
    
    view.backgroundColor = color;
    
    return view;
}

-(void)setRC_borderColor:(UIColor *)RC_borderColor{
    self.layer.borderColor = RC_borderColor.CGColor;
}

-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setRC_borderWidth:(CGFloat)RC_borderWidth{
    self.layer.borderWidth = RC_borderWidth;
}

-(CGFloat)RC_borderWidth{
    return self.layer.borderWidth;
}

-(void)setRC_cornerRadius:(CGFloat)RC_cornerRadius{
    self.layer.cornerRadius = RC_cornerRadius;
    self.layer.masksToBounds = YES;
    
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
}

-(CGFloat)RC_cornerRadius{
    return self.layer.cornerRadius;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = self.frame.origin.y + self.frame.size.height - frame.size.height;
    self.frame = frame;
}

-(UIImage *)RC_convertViewToImage{
    
    CGSize s = self.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
    //    //0.打开上下文
    //    UIGraphicsBeginImageContext(self.bounds.size);
    //    //1.画图
    //    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    //    self.contentMode = UIViewContentModeScaleAspectFill;
    //    //2.获取当前图片
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    //3.关闭上下文
    //    UIGraphicsEndImageContext();
    //4.返回图片
    return image;
}

- (void)RC_removeAllSubviews{
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end
