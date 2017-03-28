//
//  TRZXShufflingCell.m
//  TRZXShufflingView
//
//  Created by N年後 on 2017/2/14.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXShufflingCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TRZXShufflingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(NSString *)image {
    _image = image;
    [self.shufflingImageView setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"展位图"]];
}

@end
