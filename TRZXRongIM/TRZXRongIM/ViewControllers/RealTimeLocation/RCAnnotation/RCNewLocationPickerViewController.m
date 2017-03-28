//
//  RCNewLocationPickerViewController.m
//  TRZX
//
//  Created by 移动微 on 16/6/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCNewLocationPickerViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "RCDUtilities.h"
#import "RCDCommonDefine.h"

@interface RCNewLocationPickerViewController ()<MAMapViewDelegate,AMapLocationManagerDelegate>

@property(nonatomic,strong)MAMapView *mapView;

@property(nonatomic,strong)AMapLocationManager *locationManager;

@property(nonatomic,strong)UIButton *sendBtn;

@property(nonatomic,strong)UILabel *backText1;

@end

@implementation RCNewLocationPickerViewController{
    BOOL isMapViewChange;
}

-(MAMapView *)mapView{
    if (!_mapView) {
     
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64)];
        _mapView.backgroundColor = [UIColor whiteColor];
        _mapView.delegate = self;
        //为YES: 会调用代理方法。
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        _mapView.showsBuildings = NO;//显示建筑物
        _mapView.skyModelEnable = NO;//天空模式
        _mapView.rotateEnabled = NO;//是否支持旋转
        _mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 3000, 3000);
        _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 44);
    
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        
    }
    return _mapView;
}

- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView{
    // 融云提示
//    [LCProgressHUD hide];
    if(self.sendBtn.userInteractionEnabled == NO){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sendBtn.userInteractionEnabled = YES;
        });
    }
    [self.backText1 setTextColor:[UIColor trzx_YellowColor]];
}
-(void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error{
    // 融云提示
//    [LCProgressHUD hide];
    if(self.sendBtn.userInteractionEnabled == NO){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.sendBtn.userInteractionEnabled = YES;
        });
    }
    [self.backText1 setTextColor:[UIColor trzx_YellowColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    // 投融地图
//    [[KipoUpLocationManage sharedManager] startLocation];
    

//    [[KipoUpLocationManage sharedManager] startLocationWithIsSearch:YES];
    [self sendBtn];

    //统一导航条样式
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
//    [self.tabBarController.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
//    //    self.navigationController s
//    UIFont *font = [UIFont boldSystemFontOfSize:19.f];
//    NSDictionary *textAttributes = @{
//                                     NSFontAttributeName : font,
//                                     NSForegroundColorAttributeName : [UIColor whiteColor]
//                                     };
//    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
    self.title = @"当前位置";
    
    

}


-(void)sendMapInfo:(UIButton *)button{
    
    MAUserLocation *userLocation = self.mapView.userLocation;
    
    CGPoint point = [self.mapView convertCoordinate:userLocation.location.coordinate toPointToView:self.mapView];
    
    [self.mapView takeSnapshotInRect:CGRectMake(point.x  - 152.25, point.y - 84.75, 304.5, 169.5) withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        // 投融地图
//        RCLocationMessage *locationMessage = [RCLocationMessage messageWithLocationImage:resultImage location:userLocation.location.coordinate locationName:[KipoUpLocationManage sharedManager].myLocationStr];
//        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:locationMessage pushContent:@"你有新的消息请注意查收" pushData:nil success:^(long messageId) {
//            
//        } error:^(RCErrorCode nErrorCode, long messageId) {
//            
//        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MAMapViewDelegate
#pragma mark -  自定义标注
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    

        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    
        annotationView.annotation = annotation;
    
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"greenPin"];

    
        annotationView.canShowCallout = NO;
    
        return annotationView;

}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{

    if (!isMapViewChange) {
        
        [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        
        isMapViewChange = YES;
    }
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
        
        _sendBtn.frame = CGRectMake(0, 0, 50, 23);
        self.backText1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 22)];
        self.backText1.text = @"发送";
        self.backText1.font = [UIFont systemFontOfSize:16];//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
        self.backText1.textAlignment = NSTextAlignmentCenter;
        [self.backText1 setTextColor:[UIColor trzx_TextColor]];
        [_sendBtn addSubview:self.backText1];
        [_sendBtn addTarget:self action:@selector(sendMapInfo:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.userInteractionEnabled = NO;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_sendBtn];
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    return _sendBtn;
}

@end
