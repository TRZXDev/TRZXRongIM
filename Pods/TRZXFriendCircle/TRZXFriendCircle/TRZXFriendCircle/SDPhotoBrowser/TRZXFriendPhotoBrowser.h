//
//  TRZXFriendPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, TRZXFriendPhotoBrowser;

@protocol TRZXFriendBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(TRZXFriendPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(TRZXFriendPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface TRZXFriendPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, weak) id<TRZXFriendBrowserDelegate> delegate;

- (void)show;

@end
