//
//  MAUserHeadAnnotationView.h
//  TRZX
//
//  Created by Rhino on 2016/12/21.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXMap.h"
#import "TRZXMapAnnotation.h"
static NSString *kCellIdentifier_TRZXMapUserAnnotationView = @"TRZXMapUserAnnotationView";


@interface TRZXMapUserAnnotationView : MAAnnotationView
@property (nonatomic,copy)void (^didSelectAnnotationViewBlock)(TRZXMapUserAnnotationView *view);


@property (strong, nonatomic)TRZXMapAnnotation *model;
- (void)setAnimation;
- (void)closeAnimation;
@end
