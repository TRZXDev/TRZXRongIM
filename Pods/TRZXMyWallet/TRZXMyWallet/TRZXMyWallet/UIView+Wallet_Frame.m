//
//  UIView+Wallet_Frame.m
//  TRZXWallet
//
//  Created by Rhino on 2017/2/21.
//  Copyright © 2017年 Rhino. All rights reserved.
//

#import "UIView+Wallet_Frame.h"

@implementation UIView (Wallet_Frame)

@dynamic cornerRadius;


-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
