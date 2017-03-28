

#import <UIKit/UIKit.h>

@interface UIImage (TRZX)
/**
 *   纯色图片
 */
+ (UIImage *)trzx_imageWithColor:(UIColor *)color;


- (UIImage *)trzx_imageTintedWithColor:(UIColor *)color;
- (UIImage *)trzx_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;


@end

