//
//  ThemeOneCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol plusDelegate <NSObject>

- (void)plusTheme;

@end

@interface ThemeOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *companyLable;
@property (weak, nonatomic) IBOutlet UILabel *cityLable;
@property (weak, nonatomic) IBOutlet UILabel *areaLable;
@property (weak, nonatomic) IBOutlet UILabel *dayLable;
@property (weak, nonatomic) IBOutlet UILabel *peopleLable;
@property (weak, nonatomic) id <plusDelegate>delegate;
- (IBAction)plusClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;

@end
