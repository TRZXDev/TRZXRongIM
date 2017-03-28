//
//  RCDCallSingleCallViewController.m
//  TRZX
//
//  Created by 移动微 on 16/12/20.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDCallSingleCallViewController.h"

@interface RCDCallSingleCallViewController ()

@end

@implementation RCDCallSingleCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override
- (void)resetLayout:(RCConversationType)conversationType
          mediaType:(RCCallMediaType)mediaType
         callStatus:(RCCallStatus)callStatus{

    if(mediaType == RCCallMediaAudio){
        [super resetLayout:conversationType mediaType:mediaType callStatus:callStatus];
//        self.backgroundView.backgroundColor = [UIColor colorWithRed:38/255.0 green:44/255.0 blue:67/255.0 alpha:1];
        self.backgroundView.hidden = YES;
    }else{
        [super resetLayout:conversationType mediaType:mediaType callStatus:callStatus];
    }
}

@end
