//
//  UIImage+MyThemeLoad.m
//  TRZXMyTheme
//
//  Created by Rhino on 2017/3/17.
//  Copyright © 2017年 张江威. All rights reserved.
//

#import "UIImage+MyThemeLoad.h"

@implementation UIImage (MyThemeLoad)

+ (UIImage *)Theme_loadImage:(NSString *)string class:(Class)className{
   
    NSBundle *myBundle = [NSBundle bundleForClass:className];
    NSString *path = [[myBundle resourcePath]stringByAppendingPathComponent:string];
    return [UIImage imageWithContentsOfFile:path];
}


@end
