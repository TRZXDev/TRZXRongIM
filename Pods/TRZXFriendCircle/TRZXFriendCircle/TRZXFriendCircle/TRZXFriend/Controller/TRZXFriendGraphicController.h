//
//  TRZXFriendGraphicController.h
//  TRZX
//
//  Created by 张江威 on 2016/10/31.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRZXSendTimeLineHeaderView.h"

@interface TRZXFriendGraphicController : UIViewController


@property (nonatomic,strong) NSMutableArray *selectedPhotos;;
@property (nonatomic,strong) NSMutableArray *selectedAssets;

@property(strong, nonatomic)TRZXSendTimeLineHeaderView *sendTimeLineHeaderView;

@property (nonatomic,copy) void(^send1TimeLineBlock)(NSString*);


@end
