//
//  JiDuView.m
//  zidinyi
//
//  Created by sweet luo on 15/10/17.
//  Copyright © 2015年 KristyFuWa. All rights reserved.
//

#import "TRZXPJiDuView.h"
#import "TRZXPersonalAppointmentPch.h"


@implementation TRZXPJiDuView


- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        
    };
    return self;
}

- (void)JiDuNow:(int)numberPage with:(int)zongTiPage andIsPass:(NSString *)isPass;
{
    for (int i = 1; i<=zongTiPage+1; i++) {
        if (i<zongTiPage+1) {
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1))-10, 1)];
            [self addSubview:view1];
            if (i<=numberPage) {
                view1.backgroundColor = TRZXMainColor;
                if ([isPass isEqualToString:@"1"]) {
                    if (i<numberPage) {
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-10, 2, 10, 10)];
                        iv.image = [UIImage imageNamed:@"红色点"];
                        [self addSubview:iv];
                    } else if (i == numberPage) {
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-12, 0, 12, 12)];
                        iv.image = [UIImage imageNamed:@"红色点"];
                        [self addSubview:iv];
                    }
                    
                    
                } else {
                if (i<numberPage) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-10, 2, 10, 10)];
                    iv.image = [UIImage imageNamed:@"红色点"];
                    [self addSubview:iv];
                } else if (i == numberPage) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-12, 0, 12, 12)];
                    iv.image = [UIImage imageNamed:@"红色点白心"];
                    [self addSubview:iv];
                }
            }
            } else {
                if(i <= zongTiPage){
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-10, 2, 10, 10)];
                    iv.image = [UIImage imageNamed:@"灰色点"];
                    [self addSubview:iv];
                    
                }
                
                view1.backgroundColor = [UIColor grayColor];
            }
        } else {
//            if ((int)numberPage ==3) {
//                UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1)), 1)];
//                view1.backgroundColor = TRZXMainColor;
//                [self addSubview:view1];
//            }else{
            if ([isPass isEqualToString:@"1"]) {
                UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1)), 1)];
                view1.backgroundColor = TRZXMainColor;
                [self addSubview:view1];
            } else {
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1)), 1)];
            view1.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1];
                [self addSubview:view1];
            
            }
        }
//        }
        
    }
}

- (void)JiDuNow:(int)numberPage with:(int)zongTiPage;
{

//3 -------- 5
    for (int i = 1; i<=zongTiPage+1; i++) {
        if (i<zongTiPage+1) {
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1))-10, 1)];
            [self addSubview:view1];
            if (i<=numberPage) {
                view1.backgroundColor = TRZXMainColor;
                if (i<numberPage) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-10, 2, 10, 10)];
                    iv.image = [UIImage imageNamed:@"红色点"];
                    [self addSubview:iv];



                } else if (i == numberPage) {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-12, 0, 12, 12)];
                    iv.image = [UIImage imageNamed:@"红色点白心"];
                    [self addSubview:iv];
                }
            } else {
                if(i <= zongTiPage){
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*(WIDTH(self)/(zongTiPage+1))-10, 2, 10, 10)];
                    iv.image = [UIImage imageNamed:@"灰色点"];
                    [self addSubview:iv];
                    
                }
                
                view1.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1];
            }
        } else {

            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake((i-1)*WIDTH(self)/(zongTiPage+1), HEIGTH(self)/2, (WIDTH(self)/(zongTiPage+1)), 1)];
            view1.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1];
            if (numberPage==100) { // 互动课程专用
                view1.backgroundColor = TRZXMainColor;

            }
            [self addSubview:view1];





        }
        //        }
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
