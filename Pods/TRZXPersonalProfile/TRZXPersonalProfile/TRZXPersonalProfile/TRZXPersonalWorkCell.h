//
//  StudentJLNRCell.h
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/2/26.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXPersonalWorkCell: UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yincangLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhiweiLabel;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *xueliLabel;

@property(nonatomic,assign)CGFloat cellHeight;

@end
