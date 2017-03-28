//
//  MapCardCollectionView.h
//  TRZX
//
//  Created by N年後 on 2016/12/31.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRZXMapAnnotation.h"


@interface TRZXMapCardCollectionView : UIView
@property (nonatomic, copy) void(^scrollViewDidEndDeceleratingPagBlock)(NSInteger index);
@property (nonatomic, copy) void(^mapCardCollectionViewBlock)(TRZXMapAnnotation *annotation);

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *mapCards;


- (void)showMapCardCollectionViewWithIndex:(NSInteger)index;
- (void)hiddenMapCardCollectionView;




@end
