//
//  ReadThemeView.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/12.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadThemeView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ThemeTitle;
@property (weak, nonatomic) IBOutlet UILabel *PositionLable;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UITextView *ThemeContent;

@end
