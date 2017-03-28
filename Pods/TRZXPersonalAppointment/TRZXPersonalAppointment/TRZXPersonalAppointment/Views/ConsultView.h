//
//  ConsultView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *MyAlertView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLable;
@property (weak, nonatomic) IBOutlet UIButton *CancleBtn;
- (IBAction)CanCleBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *lineView;
//@property (weak, nonatomic) IBOutlet UILabel *TextLable;
@property (weak, nonatomic) IBOutlet UITextView *texttView;

@end
