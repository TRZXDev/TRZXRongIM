//
//  TRZXProjectCell.h
//  TRZXProject
//
//  Created by N年後 on 2017/2/21.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXProject.h"

static NSString *kCellIdentifier_TRZXProjectCell = @"TRZXProjectCell";


@interface TRZXProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *projectCoversImageView;
@property (strong, nonatomic) TRZXProject *project;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end
