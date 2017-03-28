//
//  WriteDataCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/23.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol writeToDelegate <NSObject>

- (void)pushBtnType:(NSString *)str;

@end

@interface WriteDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *DiDianText;
@property (weak, nonatomic) IBOutlet UITextView *dataText;
@property (weak, nonatomic) IBOutlet UIView *alearteWriteView;
- (IBAction)queRenBtn:(id)sender;
- (IBAction)quXiaoBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

@property (weak, nonatomic) id <writeToDelegate> delegate;

@end
