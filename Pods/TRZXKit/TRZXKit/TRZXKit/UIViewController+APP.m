//
//  UIViewController+MAC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/16.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "UIViewController+APP.h"
#import "UIImage+TRZX.h"
#import "UIColor+APP.h"
#import <objc/runtime.h>
@implementation UIViewController(APP)


/* 这个黑魔法不能用 会影响系统其它控件

 + (void)load {
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 Method originalMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
 Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_viewDidLoad));
 BOOL didAddMethod = class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
 if (didAddMethod) {
 class_replaceMethod([self class], @selector(swizzled_viewDidLoad), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod);
 }
 });
 }
 - (void)swizzled_viewDidLoad {
 [self swizzled_viewDidLoad];
 //    self.view.backgroundColor = WXGGlobalBackgroundColor;
 //    NSLog(@"%@ loaded", self);
 if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
 self.view.backgroundColor = [UIColor trzx_BackGroundColor];  // 这个黑魔法不能用 会影响系统其它控件
 }
 }

 */


- (void)setLeftBarItemWithString:(NSString*)string
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn setTitle:string  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [btn addTarget:self action:@selector(leftBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];

    //    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
    //    self.navigationItem.leftBarButtonItem  = leftButtonItem;

}
- (void)setLeftBarItemWithImage:(NSString *)imageName
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -25;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];

    //    UIBarButtonItem *leftButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarItemAction:)];;
    //    self.navigationItem.leftBarButtonItem=leftButtonItem;
}
- (void)setRightBarItemWithString:(NSString*)string
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn setTitle:string  forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];

    //    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction:)];
    //    self.navigationItem.rightBarButtonItem  = rightButtonItem;
}
- (void)setRightBarItemWithImage:(NSString *)imageName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    /**
     *  设置frame只能控制按钮的大小
     */
    btn.frame= CGRectMake(0, 0, 40, 44);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -25;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemAction:)];
    //    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)setRightBarItemImage:(UIImage *)imgage title:(NSString *)str{
    UIImage *img=[imgage trzx_imageTintedWithColor:[UIColor trzx_TitleColor]];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftButton setImage:imgage forState:UIControlStateNormal];
    [leftButton setImage:imgage forState:UIControlStateHighlighted];
    [leftButton setTitle:str forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [leftButton setTitleColor:[UIColor trzx_TitleColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(rightBarItemAction:)forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,barButton];
}

#pragma mark 左右两侧NavBarItem事件相应

- (void)leftBarItemAction:(UIBarButtonItem *)gesture
{
    if(self.navigationController.viewControllers.count>1)
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)rightBarItemAction:(UIBarButtonItem *)gesture
{

}

#pragma mark - TabBarItem

-(void)setTabBarItemImage:(NSString *)imageName selectedImage:(NSString *)selectImageName title:(NSString *)titleString{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc ]init];
    tabBarItem.title=titleString;
    tabBarItem.image=[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.selectedImage=[[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem=tabBarItem;
}

@end
