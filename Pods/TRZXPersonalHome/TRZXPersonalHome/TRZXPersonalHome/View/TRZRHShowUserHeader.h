//
//  TRZRHShowUserHeader.h
//  TRZX
//
//  Created by Rhino on 16/9/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TRZRHShowUserHeader :UIView<UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (void)showFromView:(UIView *)sourceView withImage:(UIImage *)image;

- (void)removeImageWindow;



@end
