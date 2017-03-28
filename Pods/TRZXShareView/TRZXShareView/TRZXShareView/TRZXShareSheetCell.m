//
//  TRZXShareSheetCell.m
//  
//
//  Created by ZZY on 16/3/28.
//
//

#import "TRZXShareSheetCell.h"
#import "TRZXShareViewDefine.h"
#import "TRZXShareItemCell.h"
#import "TRZXShareItem.h"

@interface TRZXShareSheetCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation TRZXShareSheetCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TRZXShareSheetCell";
    TRZXShareSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[TRZXShareSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = nil;
    
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zy_share_item_cell_id forIndexPath:indexPath];
    
    TRZXShareItem *item = self.itemArray[indexPath.item];
    NSAssert([item isKindOfClass:[TRZXShareItem class]], @"数组`shareArray`或者`functionArray`的元素必须为TRZXShareItem对象");
    cell.item = item;
    
    return cell;
}

//#pragma mark - UICollectionViewDelegate
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    TRZXShareItem *item = self.itemArray[indexPath.item];
//    
//    if (item.selectionHandler) {
//        item.selectionHandler();
//    }
//}

#pragma mark - setter

- (void)setItemArray:(NSArray *)itemArray
{
    _itemArray = itemArray;
}

#pragma mark - getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = nil;
        
        [_collectionView registerClass:[TRZXShareItemCell class] forCellWithReuseIdentifier:zy_share_item_cell_id];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(TRZX_ItemCellWidth, TRZX_ItemCellHeight);
    }
    return _flowLayout;
}

@end
