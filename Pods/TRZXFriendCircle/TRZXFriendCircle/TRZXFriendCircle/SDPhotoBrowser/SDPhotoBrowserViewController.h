//
//  PhotoBrowserViewController.h
//  kaopu
//
//  Created by N年後 on 15/9/10.
//  Copyright (c) 2015年 niub.la. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDPhotoBrowserViewController : UIViewController
@property (nonatomic, assign) NSUInteger currentImageIndex;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *thumbnails;
@property (nonatomic, assign) BOOL dismissType;
@end
