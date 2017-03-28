//
//  AJPhotoBrowserViewController.m
//  AJPhotoBrowser
//
//  Created by AlienJunX on 16/2/15.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJPhotoBrowserViewController.h"
#import "AJPhotoZoomingScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>

/** 主题颜色 */
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]

@interface AJPhotoBrowserViewController()<UIScrollViewDelegate,UIActionSheetDelegate>
{
    //data
    NSUInteger _currentPageIndex;
    NSMutableArray *_photos;
    
    //views
    UIScrollView *_photoScrollView;
    
    //Paging & layout
    NSMutableSet *_visiblePhotoViews,*_reusablePhotoViews;
}
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIButton *CustomDelBtn;
@property (weak, nonatomic) UIButton *CustomDoneBtn;

@end

@implementation AJPhotoBrowserViewController

#pragma mark - init

- (instancetype)initWithPhotos:(NSArray *)photos {
    self = [super init];
    if (self) {
        [self commonInit];
        _currentPageIndex = 0;
        [_photos addObjectsFromArray:photos];
    }
    return self;
}

- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index {
    self = [super init];
    if (self) {
        [self commonInit];
        _currentPageIndex = index;
        if (index < 0)
            _currentPageIndex = 0;
        if (index > photos.count-1)
            _currentPageIndex = photos.count - 1;
        
        [_photos addObjectsFromArray:photos];
    }
    return self;
}

- (void)commonInit {
    _visiblePhotoViews = [[NSMutableSet alloc] init];
    _reusablePhotoViews = [[NSMutableSet alloc] init];
    _photos = [[NSMutableArray alloc] init];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //initUI
    [self initUI];
    
    [self showPhotos];
    
    //显示指定索引
    _photoScrollView.contentOffset = CGPointMake(_currentPageIndex * _photoScrollView.bounds.size.width, 0);
}

- (void)initUI {
    //photoScrollview
    CGRect frame = self.view.bounds;
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -64)];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = UIColor.clearColor;
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    [self.view addSubview:_photoScrollView];
    
    
    //infoBar
    UIView *topView = [UIView new];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    NSArray *cons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView(==64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)];
    NSArray *cons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)];
    [self.view addConstraints:cons1];
    [self.view addConstraints:cons2];
    
    //title
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = TRZXMainColor;
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    [topView addSubview:titleLabel];
    titleLabel.text = [NSString stringWithFormat:@"1 / %lu",(unsigned long)_photos.count];
    self.titleLabel = titleLabel;
    NSArray *titleLabelCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleLabel(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    [self.view addConstraints:titleLabelCons1];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //done
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:TRZXMainColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.CustomDoneBtn = btn;
    [topView addSubview:btn];
    NSArray *doneBtnCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btn(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    NSArray *doneBtnCons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==80)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    [topView addConstraints:doneBtnCons1];
    [topView addConstraints:doneBtnCons2];
    
    //delbtn
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn setTitleColor:TRZXMainColor forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:delBtn];
    self.CustomDelBtn = delBtn;
    NSArray *delBtnCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[delBtn(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delBtn)];
    NSArray *delBtnCons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[delBtn(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delBtn)];
    [topView addConstraints:delBtnCons1];
    [topView addConstraints:delBtnCons2];
    
}

//开始显示
- (void)showPhotos {
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = floor((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (firstIndex >= _photos.count) {
        firstIndex = _photos.count - 1;
    }
    if (lastIndex < 0){
        lastIndex = 0;
    }
    if (lastIndex >= _photos.count) {
        lastIndex = _photos.count - 1;
    }
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex = 0;
    for (AJPhotoZoomingScrollView *photoView in _visiblePhotoViews) {
        photoViewIndex = photoView.tag-100;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView prepareForReuse];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

//显示指定索引的图片
- (void)showPhotoViewAtIndex:(NSInteger)index {
    AJPhotoZoomingScrollView *photoView = [self dequeueReusablePhotoView];
    if (photoView == nil) {
        photoView = [[AJPhotoZoomingScrollView alloc] init];
    }
    
    //显示大小处理
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.origin.x = bounds.size.width * index;
    photoView.tag = 100 + index;
    photoView.frame = photoViewFrame;
    
    //显示照片处理
    UIImage *photo = nil;
    id photoObj = _photos[index];
    if ([photoObj isKindOfClass:[UIImage class]]) {
        photo = photoObj;
    } else if ([photoObj isKindOfClass:[ALAsset class]]) {
        CGImageRef fullScreenImageRef = ((ALAsset *)photoObj).defaultRepresentation.fullScreenImage;
        photo = [UIImage imageWithCGImage:fullScreenImageRef];
    }
    
    //show
    [photoView setShowImage:photo];
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
}

//获取可重用的view
- (AJPhotoZoomingScrollView *)dequeueReusablePhotoView {
    AJPhotoZoomingScrollView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

//判断是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSInteger)index {
    for (AJPhotoZoomingScrollView* photoView in _visiblePhotoViews) {
        if ((photoView.tag - 100) == index) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action
- (void)doneBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didDonePhotos:)]) {
        [_delegate photoBrowser:self didDonePhotos:_photos];
    }
}

- (void)delBtnAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    actionSheet.tag = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [_photos removeObjectAtIndex:_currentPageIndex];
        
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:deleteWithIndex:)]) {
            [_delegate photoBrowser:self deleteWithIndex:_currentPageIndex];
        }
        
        //reload;
        _currentPageIndex --;
        if (_currentPageIndex == -1 && _photos.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            _currentPageIndex = (_currentPageIndex == (-1) ? 0 : _currentPageIndex);
            if (_currentPageIndex == 0) {
                [self showPhotoViewAtIndex:0];
                [self setTitlePageInfo];
            }
            _photoScrollView.contentOffset = CGPointMake(_currentPageIndex * _photoScrollView.bounds.size.width, 0);
            _photoScrollView.contentSize = CGSizeMake(_photoScrollView.bounds.size.width * _photos.count, 0);
        }
    }
}

#pragma mark - uiscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    int pageNum = floor((_photoScrollView.contentOffset.x - _photoScrollView.frame.size.width / (_photos.count+2)) / _photoScrollView.frame.size.width) + 1;
    _currentPageIndex = pageNum==_photos.count?pageNum-1:pageNum;
    [self setTitlePageInfo];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPageIndex = floor((_photoScrollView.contentOffset.x - _photoScrollView.frame.size.width / (_photos.count+2)) / _photoScrollView.frame.size.width) + 1;
    [self setTitlePageInfo];
}

- (void)setTitlePageInfo {
    NSString *title = [NSString stringWithFormat:@"%lu / %lu",_currentPageIndex+1,_photos.count];
    self.titleLabel.text = title;
}

- (void)dealloc {
    [_photos removeAllObjects];
    [_reusablePhotoViews removeAllObjects];
    [_visiblePhotoViews removeAllObjects];
}

-(void)setCustomTitle:(NSString *)title{
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor whiteColor];
    
}
-(void)setCustomDelBtnString:(NSString *)string{
    
    [self.CustomDelBtn setTitle:string forState:UIControlStateNormal];
    [self.CustomDelBtn removeTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.CustomDelBtn addTarget:self action:@selector(CusTomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.CustomDelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.CustomDelBtn.superview.backgroundColor = [UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1];
    [self.CustomDoneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.CustomDoneBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.CustomDoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
}
-(void)CusTomBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
