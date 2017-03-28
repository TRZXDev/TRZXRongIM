//
//  loadView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *numberLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIView *CellView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;
@property (weak, nonatomic) IBOutlet UILabel *smallTime;
@property (weak, nonatomic) IBOutlet UILabel *textLable;
- (IBAction)ChangeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CancelBtn;

@end
