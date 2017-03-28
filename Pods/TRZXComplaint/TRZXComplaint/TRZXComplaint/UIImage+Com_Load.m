//
//  UIImage+Com_Load.m
//  TRZXComplaint
//
//  Created by Rhino on 2017/3/15.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "UIImage+Com_Load.h"

@implementation UIImage (Com_Load)


+ (UIImage *)loadImage:(NSString *)string class:(Class)className{
    
    NSBundle *myBundle = [NSBundle bundleForClass:className];
    NSString *path = [[myBundle resourcePath]stringByAppendingPathComponent:string];
    return [UIImage imageWithContentsOfFile:path];
}

@end
