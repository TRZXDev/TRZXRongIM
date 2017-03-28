//
//  TRZXShufflingCell.h
//  TRZXShufflingView
//
//  Created by N年後 on 2017/2/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRZXShufflingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shufflingImageView;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *image;


@end
