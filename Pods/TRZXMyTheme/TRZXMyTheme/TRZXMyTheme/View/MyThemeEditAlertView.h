//
//  MyThemeEditAlertView.h
//  HBVLinkedTextViewExample
//
//  Created by 投融在线 on 16/5/3.
//  Copyright © 2016年 herbivore. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyThemeEditAlertViewDelegate <NSObject>

- (void)editDownChangeTextViewWithString:(NSString *)string;

@end

@interface MyThemeEditAlertView : UIView

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,weak)id <MyThemeEditAlertViewDelegate>delegate;

@property (nonatomic,strong)UIButton *canclebutton;
@property (nonatomic,strong)UIButton *saveButton;

@property (nonatomic,assign)NSInteger indexFirst;
@property (nonatomic,assign)NSInteger indexSecond;

@property (nonatomic,copy) NSString *titleFirst;
@property (nonatomic,copy) NSString *titleSecond;

- (void)show;

- (void)dismiss;

@end
