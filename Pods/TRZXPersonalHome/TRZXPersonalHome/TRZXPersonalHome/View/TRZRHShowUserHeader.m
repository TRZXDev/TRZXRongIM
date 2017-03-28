//
//  TRZRHShowUserHeader.m
//  TRZX
//
//  Created by Rhino on 16/9/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZRHShowUserHeader.h"

@interface TRZRHShowUserHeader()<UIActionSheetDelegate>
{
    UIScrollView *sv;
    
    UIImageView *imageView;
    
    CGRect originalRect;
}

@end

@implementation TRZRHShowUserHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageWindow)];
        [self addGestureRecognizer:singleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        [self addGestureRecognizer:longPress];
        
        [singleTap requireGestureRecognizerToFail:longPress];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)showFromView:(UIView *)sourceView withImage:(UIImage *)image
{
    UIView *superView = [sourceView superview];
    
    //nil表示转换到window坐标系统
    CGRect rect = [superView convertRect:sourceView.frame toView:nil];
    
    originalRect = rect;

    sv = [[UIScrollView alloc] initWithFrame:self.bounds];
    sv.delegate = self;
    sv.maximumZoomScale = 2.0;
    
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = rect;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [sv addSubview:imageView];
    
    [self addSubview:sv];
    
    [self showAnimation:imageView];
    
}

- (void)removeImageWindow
{
    sv.zoomScale = 1.0f;
    [self removeAnimation:imageView];
}

- (void)saveImage:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                      
                                                                delegate:self
                                      
                                                       cancelButtonTitle:@"取消"
                                      
                                                  destructiveButtonTitle:nil
                                      
                                                       otherButtonTitles:@"保存图片到相册",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [actionSheet showInView:self];
    }
    
}

#pragma mark -
#pragma mark Animation

- (void)showAnimation:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = [UIScreen mainScreen].bounds;
    } completion:NULL];
}

- (void)removeAnimation:(UIView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        view.frame = originalRect;
    } completion:^(BOOL finished){
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

#pragma mark --- UIActionSheetDelegate---
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败,未开启相册权限" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //转圈先屏蔽了
//        [LCProgressHUD showInfoMsg:@"保存失败,未开启相册权限"]; // 显示提示
    }
}




@end
