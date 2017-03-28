//
//  RCDPublicCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicCell.h"
#import "RCDPublicMessage.h"
#import "RCDCommonDefine.h"

@interface RCDPublicCell()

-(void)initialze;

@end

@implementation RCDPublicCell

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
    return CGSizeMake(collectionViewWidth, 90 + extraHeight);
}

-(void)initialze{
    
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    [self.nameLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.bubbleBackgroundView addSubview:self.nameLabel];
    
    self.separatorView = [UIView RC_viewWithColor:[UIColor trzx_BackGroundColor]];
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.promptLabel setFont:[UIFont systemFontOfSize:12]];
    self.promptLabel.textColor = [UIColor trzx_TextColor];
    [self.promptLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.bubbleBackgroundView addSubview:self.promptLabel];
    [self.bubbleBackgroundView addSubview:self.separatorView];
    
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bubbleBackgroundView addSubview:self.iconImageView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.bubbleBackgroundView addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleBackgroundViewDidTap:)];
    [self.bubbleBackgroundView addGestureRecognizer:tap];
}

- (void)bubbleBackgroundViewDidTap:(UITapGestureRecognizer *)tap{
    [self didTapMessageCell:self.model];
}


-(void)setDataModel:(RCMessageModel *)model{
    
    [super setDataModel:model];
    
    [self setAutoLayout];
}

-(void)setAutoLayout{
    CGFloat portraitW = [RCIM sharedRCIM].globalMessagePortraitSize.width;
    
    RCDPublicMessage *message = (RCDPublicMessage *)self.model.content;
    
    if (message.publicName) {
        self.nameLabel.text = message.publicName;
    }
    if (message.photo) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:message.photo]];
    }
    
    self.promptLabel.text = @"订阅刊名片";
    
    if (self.messageDirection == MessageDirection_RECEIVE) {
        
        self.bubbleBackgroundView.frame = CGRectMake(0, 0, 210, 90);
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDBusinessCard_message_receive"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8, image.size.height * 0.2, image.size.width * 0.2)];
    }else{
        self.bubbleBackgroundView.frame = CGRectMake(self.messageContentView.width - 210, 0, 210, 90);
        
        self.bubbleBackgroundView.image = [UIImage RC_BundleImgName:@"RCDBusinessCard_message_sender"];
        UIImage *image = self.bubbleBackgroundView.image;
        self.bubbleBackgroundView.image = [self.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.2, image.size.height * 0.2, image.size.width * 0.8)];
    }
    self.iconImageView.frame = CGRectMake(15, 10, portraitW, portraitW);
    self.nameLabel.frame = CGRectMake(portraitW+10+10, 25,self.bubbleBackgroundView.width - portraitW+10+10, 0);
    self.promptLabel.frame = CGRectMake(10, 70, 80, 20);
    self.separatorView.frame =  CGRectMake(5, 69, 205, 1);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.nameLabel sizeToFit];
    self.nameLabel.width = self.bubbleBackgroundView.width - portraitW - 15;
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
