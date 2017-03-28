//
//  MapCardCollectionView.m
//  TRZX
//
//  Created by N年後 on 2016/12/31.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXMapCardCollectionView.h"
#import "TRZXMapUserCollectionViewCell.h"
#import "TRZXMapAnnotation.h"
#import "TRZXKit.h"
@interface TRZXMapCardCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate>



@end

@implementation TRZXMapCardCollectionView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        CGFloat itemW =[[UIScreen mainScreen] bounds].size.width;
        CGFloat itemH = 97;

        // layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        layout.itemSize = CGSizeMake(itemW, 97);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;


        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, itemH) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.scrollsToTop = YES;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        // register cell


        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TRZXMapUserCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier_TRZXMapUserCollectionViewCell];


        [self addSubview:self.collectionView];


    }
    return self;
}







-(void)setMapCards:(NSMutableArray *)mapCards{
        _mapCards = mapCards;
        [_collectionView reloadData];   
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return _mapCards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     TRZXMapAnnotation *annotation = _mapCards[indexPath.row];
        TRZXMapUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_TRZXMapUserCollectionViewCell forIndexPath:indexPath];
        cell.model = annotation;
        return cell;

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    TRZXMapAnnotation *annotation = _mapCards[indexPath.row];
    if (self.mapCardCollectionViewBlock) {
        self.mapCardCollectionViewBlock(annotation);
    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 动画停止, 重新定位到第 50 组模型
    int inc = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % _mapCards.count;
    if (self.scrollViewDidEndDeceleratingPagBlock) {
        self.scrollViewDidEndDeceleratingPagBlock(inc);
    }
}

- (void)showMapCardCollectionViewWithIndex:(NSInteger)index{

    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, self.height, self.width, self.height);
    }];

}
- (void)hiddenMapCardCollectionView{

    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, -self.width, self.width, self.height);

    }];
}


@end
