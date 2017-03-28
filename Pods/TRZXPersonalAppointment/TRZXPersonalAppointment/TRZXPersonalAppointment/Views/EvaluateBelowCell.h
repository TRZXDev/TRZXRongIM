//
//  EvaluateBelowCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellButtonDelegate <NSObject>

- (void)TransmitType:(NSString *)str;

@end

@interface EvaluateBelowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBackView;
@property (weak, nonatomic) IBOutlet UILabel *CellTitleLable;
- (IBAction)ConsultBtn:(id)sender;
- (IBAction)Myintroduce:(id)sender;
- (IBAction)TimeSite:(id)sender;
- (IBAction)IphoneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *jieShaoLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;

@property (weak, nonatomic)id <CellButtonDelegate> delegate;

@end
