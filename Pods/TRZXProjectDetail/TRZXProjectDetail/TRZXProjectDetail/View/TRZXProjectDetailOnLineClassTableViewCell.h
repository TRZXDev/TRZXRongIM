//
//  TRZXProjectDetailOnLineClassTableViewCell.h
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/4.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRZXRecommendCoursez, TRZXRecommendExpertTopic;

@interface TRZXProjectDetailOnLineClassTableViewCell : UITableViewCell

@property (nonatomic, strong) TRZXRecommendCoursez *coursezModel;

@property (nonatomic, strong) TRZXRecommendExpertTopic *expertTopicModel;

@end
