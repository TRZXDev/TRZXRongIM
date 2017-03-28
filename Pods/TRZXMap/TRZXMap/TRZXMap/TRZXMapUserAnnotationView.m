//
//  MAUserHeadAnnotationView.m
//  TRZX
//
//  Created by Rhino on 2016/12/21.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXMapUserAnnotationView.h"
#import "TRZXKit.h"
#import "UIImageView+AFNetworking.h"

static const CGFloat userScale = 1.2;

@interface TRZXMapUserAnnotationView ()

@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)CALayer *layers;

@end

@implementation TRZXMapUserAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 47*1.3, 50*1.3);
        self.backgroundColor = [UIColor clearColor];

        _bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"map_user_normal"];
        [self addSubview:self.bgImageView];


        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, self.width-6, self.width-6)];
        _titleLabel.textColor = [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];

        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, self.width-6, self.width-6)];
        [self addSubview:self.headImageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
        [self addGestureRecognizer:tap];

    }
    
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    self.headImageView.layer.cornerRadius = _headImageView.width/2;
    self.headImageView.clipsToBounds = YES;

}

-(void)setModel:(TRZXMapAnnotation *)model{


    if (_model!=model) {
        _model = model;
        if (model.count>0) {
            self.headImageView.hidden = YES;
            self.bgImageView.image = [UIImage imageNamed:@"map_user_normal"];
            self.titleLabel.text =  model.count;
        }else{
            self.headImageView.hidden = NO;
            [self.headImageView setImageWithURL:[NSURL URLWithString:model.photo]];
        }
        
    }
    
    
}




-(void)actionTap{
    if (self.didSelectAnnotationViewBlock) {
        self.didSelectAnnotationViewBlock(self);
    }

}



- (void)setAnimation{

    [UIView animateWithDuration:0.2 animations:^{
        self.bgImageView.image = [UIImage imageNamed:@"map_user_selected"];
        self.transform = CGAffineTransformMakeScale(userScale, userScale);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeAnimation{
    [UIView animateWithDuration:0.2 animations:^{
        self.bgImageView.image = [UIImage imageNamed:@"map_user_normal"];
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
