//
//  PikerTimeCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/23.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addDDDelegate <NSObject>

- (void)addDD;

@end

@interface PikerTimeCell : UITableViewCell
- (IBAction)addTime:(id)sender;
- (IBAction)addDD:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pikerTime;

@property (weak, nonatomic) id<addDDDelegate>delegate;

@end
