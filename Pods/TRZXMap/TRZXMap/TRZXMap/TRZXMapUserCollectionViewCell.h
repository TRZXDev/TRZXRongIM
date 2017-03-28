//
//  TRMapStockCollectionViewCell.h
//  TRZX
//
//  Created by Rhino on 2016/12/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXMapAnnotation.h"



static NSString *kCellIdentifier_TRZXMapUserCollectionViewCell = @"TRZXMapUserCollectionViewCell";

///////股东
@interface TRZXMapUserCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign)TRZXMapAnnotation *model;

@end
