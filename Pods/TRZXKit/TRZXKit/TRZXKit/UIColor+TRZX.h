//
//  UIColor+Mac.h
//  MacKit
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor(TRZX)

/**
 *   用HexString 生成 UIColor
 *
 *  @param hexString   #RGB  #ARGB   #RRGGBB  #AARRGGBB 或者不带#
 */
+ (UIColor *)trzx_colorWithHexString:(NSString *)hexString;


@end
