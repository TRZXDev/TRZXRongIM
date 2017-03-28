//
//  TRZXProjectDetailProjectHistoryTableViewCell.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/3.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRZXProjectDetailDataDynamicModel;

@interface TRZXProjectDetailProjectHistoryTableViewCell : UITableViewCell

- (void)setModel:(TRZXProjectDetailDataDynamicModel *)model indexPath:(NSIndexPath *)indexPath;

@end
