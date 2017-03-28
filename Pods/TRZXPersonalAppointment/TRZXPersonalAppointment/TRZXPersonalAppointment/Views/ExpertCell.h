//
//  ExpertCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyExpertModel.h"
@interface ExpertCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *zuixinImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *meetState;
@property (weak, nonatomic) IBOutlet UILabel *seeTime;
@property (weak, nonatomic) IBOutlet UILabel *seeTitle;
@property (copy, nonatomic) NSString *typeSelf;

@property (copy, nonatomic) NSString *vipStr;

@property (strong, nonatomic)MyExpertModel *model;

-(NSString*)getMeetStatus:(NSInteger)meetStatus;

@end
