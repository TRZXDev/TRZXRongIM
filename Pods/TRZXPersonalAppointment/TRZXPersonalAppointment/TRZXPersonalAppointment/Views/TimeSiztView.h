//
//  TimeSiztView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSiztView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *TimeSizt_AlertView;
@property (weak, nonatomic) IBOutlet UILabel *TimeLable;
@property (weak, nonatomic) IBOutlet UILabel *DateLable;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (weak, nonatomic) IBOutlet UILabel *SiztLable;
@property (weak, nonatomic) IBOutlet UILabel *SiztTile_lable;
//@property (weak, nonatomic) IBOutlet UILabel *Sizt_One;
@property (weak, nonatomic) IBOutlet UITextView *textttView;
@property (weak, nonatomic) IBOutlet UIButton *Sizt_CancleBtn;
- (IBAction)Sizt_CancleClick:(id)sender;


@end
