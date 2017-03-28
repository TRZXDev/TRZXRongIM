//
//  ChoosetimeCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/11.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol deleteCellDelegate <NSObject>

- (void)deleteNymber:(NSString *)number;

@end

@interface ChoosetimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NumberLable;
@property (weak, nonatomic) IBOutlet UIView *CellBackView;
@property (weak, nonatomic) IBOutlet UILabel *TimeLable;
@property (weak, nonatomic) IBOutlet UILabel *SiztTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *SiztDetails;
@property (weak, nonatomic) IBOutlet UIButton *guanBiBtn;


@property (weak, nonatomic) id<deleteCellDelegate>delegate;

- (IBAction)CloseBtn:(id)sender;

@end
