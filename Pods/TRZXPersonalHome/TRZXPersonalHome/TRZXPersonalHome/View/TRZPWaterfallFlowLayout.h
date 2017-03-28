
#import <UIKit/UIKit.h>

@class TRZPWaterfallFlowLayout;

@protocol TRWaterfallFlowLayoutDelegate <NSObject>

@required
- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(TRZPWaterfallFlowLayout *)collectionViewLayout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TRZPWaterfallFlowLayout : UICollectionViewLayout
@property (nonatomic, weak) id<TRWaterfallFlowLayoutDelegate> delegate;
@end
