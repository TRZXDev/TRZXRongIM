//
//  ChongzhiVC.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/29.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletBaseViewController.h"

@interface ChongzhiVC : WalletBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textQB;
- (IBAction)nextBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *moneyView;

@property (copy, nonatomic) NSString *typeStr;
@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
