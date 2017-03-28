//
//  MAListStockTableViewCell.h
//  TRZX
//
//  Created by Rhino on 2016/12/23.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXMapAnnotation.h"
static NSString *kCellIdentifier_TRZXMapListCell = @"TRZXMapListCell";

@interface TRZXMapListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (strong, nonatomic)TRZXMapAnnotation *model;
@end
