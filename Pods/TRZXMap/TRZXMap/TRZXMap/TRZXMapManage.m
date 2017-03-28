//
//  TRZXMapLocationManage.m
//  TRZXMap
//
//  Created by N年後 on 2017/3/7.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapManage.h"
#import "TRZXNetwork.h"
@interface TRZXMapManage ()<AMapLocationManagerDelegate>{

}
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation TRZXMapManage
+ (instancetype)sharedManager {
    static TRZXMapManage *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)startLocation:(locationManageBlock)block{

    __weak TRZXMapManage *weakSelf = self;

    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {

        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {  //定位失败
                return;
            }
        }

        if (location)
        {
            if (regeocode)
            {
                //位置坐标
                _curLocation = location.coordinate;

                [weakSelf uploadLocation:regeocode curLocation:_curLocation];

                block(regeocode);
                
            }
        }

        //============================
        
    }];


}


-(void)uploadLocation:(AMapLocationReGeocode *)regeocode curLocation:(CLLocationCoordinate2D)curLocation {


    NSString *lat = [NSString stringWithFormat:@"%f",curLocation.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",curLocation.longitude];

    NSDictionary *params = @{
                             @"adcode":regeocode.adcode==nil?@"":regeocode.adcode,
                             @"number":regeocode.number==nil?@"":regeocode.number,
                             @"district":regeocode.district==nil?@"":regeocode.district,
                             @"citycode":regeocode.citycode==nil?@"":regeocode.citycode,
                             @"city":regeocode.city==nil?@"":regeocode.city,
                             @"province":regeocode.province==nil?@"":regeocode.province,
                             @"address":regeocode.formattedAddress==nil?@"":regeocode.formattedAddress,
                             @"latitude":lat,
                             @"longitude":lon,
                             };

    [TRZXNetwork requestWithUrl:@"/api/map/places/savePlaces" params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id response, NSError *error) {

        if (response) {

        

        }else{


        }
    }];


}







- (AMapLocationManager *)locationManager{
    if (!_locationManager) {

        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        //要在iOS 9及以上版本使用后台定位功能, 需要保证"Background Modes"中的"Location updates"处于选中状态
        [_locationManager setAllowsBackgroundLocationUpdates:NO];
        //   定位超时时间，最低2s，此处设置为2s
        _locationManager.locationTimeout =2;
        //   逆地理请求超时时间，最低2s，此处设置为2s
        _locationManager.reGeocodeTimeout = 2;

    }
    return _locationManager;
}

@end
