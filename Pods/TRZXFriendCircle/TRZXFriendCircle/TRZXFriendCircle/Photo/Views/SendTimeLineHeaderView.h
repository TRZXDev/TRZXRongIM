//
//  SendTimeLineHeaderView.h
//  tourongzhuanjia
//
//  Created by N年後 on 16/4/23.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTimeLineHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextView *photoTextView;
@property (weak, nonatomic) IBOutlet UILabel *bgTextLabel;
@property (weak, nonatomic) IBOutlet UIView *shareContentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
