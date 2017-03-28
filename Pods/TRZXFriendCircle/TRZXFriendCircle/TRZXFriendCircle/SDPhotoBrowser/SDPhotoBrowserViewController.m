//
//  PhotoBrowserViewController.m
//  kaopu
//
//  Created by N年後 on 15/9/10.
//  Copyright (c) 2015年 niub.la. All rights reserved.
//

#import "SDPhotoBrowserViewController.h"
#import "SDPhotoBrowser.h"
#import "SDBrowserImageView.h"

@interface SDPhotoBrowserViewController ()<SDPhotoBrowserDelegate>

@end

@implementation SDPhotoBrowserViewController{
    SDPhotoBrowser *myBrowser;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] initWithFrame:self.view.bounds];
    browser.imageCount = self.thumbnails.count>0?self.thumbnails.count:self.images.count; // 图片总数
    browser.currentImageIndex = _currentImageIndex;
    browser.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    browser.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:browser];
    myBrowser = browser;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];



}



- (void)orientChange:(NSNotification *)noti
{


    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */

    switch (orient)
    {
        case UIDeviceOrientationPortrait:



            self.view.layer.transform = CATransform3DMakeRotation(M_PI*2 , 0, 0, 1.0);


            break;
        case UIDeviceOrientationLandscapeLeft:



            self.view.layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1.0);



            break;
        case UIDeviceOrientationPortraitUpsideDown:


            break;
        case UIDeviceOrientationLandscapeRight:

            self.view.layer.transform = CATransform3DMakeRotation(-M_PI / 2, 0, 0, 1.0);

            break;

        default:
            break;
    }
}




#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    if (self.thumbnails.count>0){
        return self.thumbnails[index];
    }
    return nil;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.images.count>0){
        
        if ([self.images[index] isKindOfClass:[NSString class]]) {
            
            if (![self.images[index] hasPrefix:@"http:"]) {
                return [[NSURL alloc]initFileURLWithPath:self.images[index]];
            }
            
            NSURL *URL = [NSURL URLWithString:self.images[index]];
            return URL;
        }
    }
    return nil;
}

- (void)photoBrowser:(SDPhotoBrowser *)browser didSelectIndex:(NSInteger)index{

    if (self.dismissType) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{        
        [self dismissViewControllerAnimated:true completion:^{
            
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
