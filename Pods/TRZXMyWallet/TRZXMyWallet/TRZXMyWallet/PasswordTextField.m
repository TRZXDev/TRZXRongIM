//
//  PasswordTextField.m
//  FJF
//
//  Created by fengjiefeng on 15/8/9.
//  Copyright (c) 2015年 fengjiefeng. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
