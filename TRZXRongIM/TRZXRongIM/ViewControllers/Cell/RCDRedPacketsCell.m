//
//  RCDRedPacketsCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/3.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDRedPacketsCell.h"
#import "RCDRedPacketsMessage.h"
#import "RCDCommonDefine.h"

@implementation RCDRedPacketsCell

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
    return CGSizeMake(collectionViewWidth, 85 + extraHeight);
}

-(void)initialze{
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.contentLabel setFont:[UIFont systemFontOfSize:10]];
    
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.bubbleBackgroundView addSubview:self.contentLabel];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

-(void)setDataModel:(RCMessageModel *)model{
    
    [super setDataModel:model];
    
    [self setAutoLayout];
}

-(void)setAutoLayout{
    
    RCDRedPacketsMessage *message = (RCDRedPacketsMessage *)self.model.content;
    if (message.title) {
        self.titleLabel.text = message.title;
    }
    if (message.content) {
        self.contentLabel.text = message.content;
    }
    
    if (self.messageDirection == MessageDirection_RECEIVE) {
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, 210, 85);
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDRedPackets_Message_Receive"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
    }else{
        self.bubbleBackgroundView.frame = CGRectMake(self.messageContentView.width - 210, 0, 210, 85);
        
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDRedPackets_Message_Sender"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2, image.size.height * 0.2, image.size.width * 0.8)];
    }
    self.titleLabel.frame = CGRectMake(45, 15,self.bubbleBackgroundView.width - 84, 0);
    [self.titleLabel sizeToFit];
    self.contentLabel.frame = CGRectMake(45, CGRectGetMaxY(self.titleLabel.frame),self.bubbleBackgroundView.width - 84, 0);
    [self.contentLabel sizeToFit];
}


#pragma mark - Action
- (void)tapPressed:(UITapGestureRecognizer *)tap{
    [self didTapMessageCell:self.model];
}
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
