//
//  RCDCollectionCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDCollectionCell.h"
#import "RCDCollectionMessage.h"
#import "NSString+RCExtension.h"
#import "RCDCommonDefine.h"
#import "UIView+RCExtension.h"
#import "UIImageView+WebCache.h"
#import <TRZXKit/UIColor+APP.h>
#import <TRZXKit/UIView+TRZX.h>

@implementation RCDCollectionCell

-(NSDictionary *)attributeDictionary{
    if (self.messageDirection == MessageDirection_SEND) {
        return @{
                 @(NSTextCheckingTypeLink):@{NSForegroundColorAttributeName :[UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber):@{NSForegroundColorAttributeName:[UIColor blueColor]}
                 };
    }else{
        return @{
                 @(NSTextCheckingTypeLink):@{NSForegroundColorAttributeName:[UIColor blueColor]},
                 @(NSTextCheckingTypePhoneNumber):@{NSForegroundColorAttributeName:[UIColor blueColor]}
                 };
    }
    return nil;
}

-(NSDictionary *)highlightedAttributeDictionady{
    return [self attributeDictionary];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialze];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialze];
    }
    return self;
}

+(CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    CGFloat portraitW = [RCIM sharedRCIM].globalMessagePortraitSize.width;
    RCDCollectionMessage *message = (RCDCollectionMessage *)model.content;
        CGFloat cellHeight = [message.collectionTitle RC_sizeWithViewWidth:200 FontSize:14].height + portraitW + 10 + 45;
    return CGSizeMake(collectionViewWidth,  cellHeight + extraHeight);
}

-(void)initialze{
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.textColor = [UIColor trzx_TitleColor];
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.textColor = [UIColor trzx_TextColor];
    [self.contentLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.bubbleBackgroundView addSubview:self.contentLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    self.pictureImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView addSubview:self.pictureImage];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleBackgroundViewDidTap:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

- (void)bubbleBackgroundViewDidTap:(UITapGestureRecognizer *)Tap{
    [self didTapMessageCell:self.model];
}

-(void)setDataModel:(RCMessageModel *)model{
    
    [super setDataModel:model];
    
    [self setAutoLayout];
}

-(void)setAutoLayout{
    CGFloat portraitW = [RCIM sharedRCIM].globalMessagePortraitSize.width;
    
    RCDCollectionMessage *message = (RCDCollectionMessage *)self.model.content;
    if (message.collectionContent) {
        self.contentLabel.text = message.collectionContent;
        self.contentLabel.numberOfLines = 0;
    }
    
    if (message.collectionTitle) {
        self.titleLabel.text = message.collectionTitle;
        self.titleLabel.numberOfLines = 0;
    }
    if (message.collectionPicture) {
        [self.pictureImage setContentMode:UIViewContentModeScaleAspectFit];
        [self.pictureImage sd_setImageWithURL:[NSURL URLWithString:message.collectionPicture] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
    }
    CGFloat cellHeight = [message.collectionTitle RC_sizeWithViewWidth:210 FontSize:14].height + portraitW + 10 + 45 ;
    if (self.messageDirection == MessageDirection_RECEIVE) {
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, 220, cellHeight);
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDCollection_Message_Receive"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
    }else{
        self.bubbleBackgroundView.frame = CGRectMake(self.messageContentView.width - 220, 0, 220, cellHeight);
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDCollection_Message_Sender"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2, image.size.height * 0.2, image.size.width * 0.8)];
    }
    
    self.titleLabel.frame = CGRectMake(10, 15,self.bubbleBackgroundView.width - 20, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.bubbleBackgroundView.width - 20;
    self.pictureImage.frame = CGRectMake(self.bubbleBackgroundView.width - portraitW - 20, CGRectGetMaxY(self.titleLabel.frame)+10, portraitW, portraitW);
    self.contentLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5,self.bubbleBackgroundView.width - portraitW - 40, portraitW + 5);
    self.bubbleBackgroundView.height = self.contentLabel.bottom + 10;
}

#pragma mark - Action
-(void)longPressed:(UILongPressGestureRecognizer *)press{
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    }else if(press.state == UIGestureRecognizerStateBegan){
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model{
    [self.delegate didTapMessageCell:model];
}

@end
