//
//  TRZXMapViewController.m
//  TRZXMap
//
//  Created by N年後 on 2017/2/28.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXMapViewController.h"
#import "TRZXKit.h"
#import "TRZXMapUserAnnotationView.h"
#import "TRZXMap.h"
#import "TRZXMapCardCollectionView.h"
#import "Masonry.h"
static CGFloat MapStockBottomHeight = 97;


@interface TRZXMapViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic,strong) MAMapView  *mapView;
@property (nonatomic, strong) TRZXMapUserAnnotationView *currentAnnotationView;
@property (nonatomic,strong)TRZXMapCardCollectionView *mapCardCollectionView;

@property (nonatomic, strong) NSMutableArray* currentlist;
@property (nonatomic,strong)UIButton *centerButton;
@property (nonatomic,strong) AMapSearchAPI    *searchApi;
@property (nonatomic,strong) AMapReGeocodeSearchRequest *searchRequest;



@property (nonatomic) BOOL isloading;
@property (nonatomic) BOOL isLocationSuccess;



@end

@implementation TRZXMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.mapView];

    [self.view addSubview:self.mapCardCollectionView];
    [self.view addSubview:self.centerButton];
    [_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mapCardCollectionView.mas_top).offset(-8);
        make.left.equalTo(self.mapCardCollectionView.mas_left).offset(8);
        make.height.equalTo(@(40));
        make.width.equalTo(@(40));
    }];





    // Do any additional setup after loading the view.
}

-(void)setTradeIds:(NSArray*)tradeIds stageIds:(NSArray *)stageIds{
    [self hiddenMapCardCollectionView];
    self.mapViewModel.tradeIds = tradeIds;
    self.mapViewModel.stageIds= stageIds;
    [self requestSignal_list];

}
-(void)setCity:(NSDictionary *)dic{

    CLLocationCoordinate2D currentCoordinate = CLLocationCoordinate2DMake([dic[@"latitude"] floatValue], [dic[@"longitude"] floatValue]);

    [self hiddenMapCardCollectionView];

    [self.mapView setCenterCoordinate:currentCoordinate animated:NO];
    [self.mapView setZoomLevel:10 animated:YES];//
    self.mapViewModel.zoomLevel = 10;
    self.mapViewModel.centerCoordinate = currentCoordinate;
}

// 发起请求
- (void)requestSignal_list {




    [self.mapViewModel.requestSignal_list subscribeNext:^(id x) {

        [self.mapView removeAnnotations:self.currentlist]; //移除标注
        [self.currentlist removeAllObjects];

        self.currentlist = self.mapViewModel.list;
        [self.mapView addAnnotations:self.currentlist]; // 添加标注

        self.mapCardCollectionView.mapCards = [NSMutableArray arrayWithArray:self.currentlist];


        if (!self.isloading) {
            self.isloading = !self.isloading;
            self.currentAnnotationView = (TRZXMapUserAnnotationView *)[self.mapView viewForAnnotation:self.currentlist[0]];
            [self didSelectAnnotationView:self.currentAnnotationView];
        }

        // 请求完成后，更新UI

    } error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应提示

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


    // Dispose of any resources that can be recreated.
}




 // 当位置更新时,会进定位回调,通过回调函数,能获取到定位点的经纬度坐标,示例代码如下:


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        CLLocation *newLocation = userLocation.location;
        //判断时间
        NSTimeInterval locationAge = [newLocation.timestamp timeIntervalSinceNow];
        if (locationAge > 5.0) {
            return;
        }
        //判断水平精度是否有效
        if(newLocation.horizontalAccuracy >0 && newLocation.horizontalAccuracy < 150) {
            CLLocationCoordinate2D myCoorDinate = [newLocation coordinate];
            _mapView.centerCoordinate = myCoorDinate;
            _mapView.showsUserLocation = NO;


//            [self.searchApi AMapReGoecodeSearch:self.searchRequest];


            // 反地理编码，根据定位到的经纬度转换成城市街道名称等信息
            CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
            [geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *placemark = [placemarks firstObject];
                userLocation.title = placemark.name;
                userLocation.subtitle = placemark.locality;
                self.mapViewModel.currentCoordinate =userLocation.location.coordinate;
                self.mapViewModel.centerCoordinate = userLocation.location.coordinate;
                self.mapViewModel.locality = placemark.locality;

                if (self.mapInitCompleteBlock) {
                    self.mapInitCompleteBlock(self.mapViewModel);
                }

                self.isLocationSuccess = !self.isLocationSuccess;
                // 缩放到16级

                NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>取地理位置成功==%f",self.mapViewModel.zoomLevel);

                [self.mapView setZoomLevel:16 animated:YES];// 移动到16级别

                NSLog(@"获取地理位置成功 name = %@ locality = %@ ", placemark.name, placemark.locality);


            }];


        }
    }
}




- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{

    if ([annotation isKindOfClass:[TRZXMapAnnotation class]]) {
        TRZXMapAnnotation *model = (TRZXMapAnnotation*)annotation;
        TRZXMapUserAnnotationView *annotationView = (TRZXMapUserAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kCellIdentifier_TRZXMapUserAnnotationView];
        if (annotationView == nil){
            annotationView = [[TRZXMapUserAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kCellIdentifier_TRZXMapUserAnnotationView];
        }
        annotationView.model = model;

        annotationView.didSelectAnnotationViewBlock = ^(TRZXMapUserAnnotationView* view){
            [self didSelectAnnotationView:view];
        };

        return annotationView;
    }
    return nil;
    
}


// 点击图像选中状态
-(void)didSelectAnnotationView:(TRZXMapUserAnnotationView*)annotationView{


    // 处理聚合数据
    if ([annotationView.model.level isEqualToString:@"adcode"]) {


        if(_mapView.zoomLevel+1>=10){ // 12-10

            [self didSelectAnnotation:annotationView.model.locaCoordinate zoomLevel:14];
        }else{ // 9-3
            [self didSelectAnnotation:annotationView.model.locaCoordinate zoomLevel:9];
        }

    }else if ([annotationView.model.level isEqualToString:@"citycode"]){

        if(_mapView.zoomLevel+1>=10){ // 12-10
            [self didSelectAnnotation:annotationView.model.coordinate zoomLevel:14];
        }else{ // 9-3
            [self didSelectAnnotation:annotationView.model.coordinate zoomLevel:9];
        }

    }else{

        [self.currentAnnotationView closeAnimation]; //取消上一个小选中状态

        [annotationView setAnimation]; //选中
        [self showMapCardCollectionView];
        [self.mapView selectAnnotation:annotationView.annotation animated:YES];
        self.currentAnnotationView = annotationView;


        [self.mapCardCollectionView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:annotationView.model.index inSection:0]atScrollPosition:UICollectionViewScrollPositionNone animated:NO];


    }

}






/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction
{


    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>地图缩放结束后调用此接口==%f",self.mapView.zoomLevel);

    self.mapViewModel.zoomLevel = self.mapView.zoomLevel;


    [self mapDidMoveByUserAndmapDidZoomByUser:wasUserAction];


}


/**
 *  地图移动结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>地图移动结束后调用此接口==%f",self.mapView.zoomLevel);
    self.mapViewModel.centerCoordinate = self.mapView.centerCoordinate;

    [self mapDidMoveByUserAndmapDidZoomByUser:wasUserAction];

}

-(void)didSelectAnnotation:(CLLocationCoordinate2D)coordinate zoomLevel:(CGFloat)zoomLevel {

    [self.mapView setCenterCoordinate:coordinate animated:NO];
    [self.mapView setZoomLevel:zoomLevel animated:YES];//
    self.mapViewModel.zoomLevel = zoomLevel;
    self.mapViewModel.centerCoordinate = coordinate;
    
}

-(void)mapDidMoveByUserAndmapDidZoomByUser:(BOOL)wasUserAction{



        if (self.isLocationSuccess) { // 已经完成定位
            [self.currentAnnotationView closeAnimation];
            [self hiddenMapCardCollectionView];// 隐藏卡片View
            if (!self.mapViewModel.isLoading) {
                [self requestSignal_list];
            }
        }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (MAMapView *)mapView{

    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;

    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _mapView.showsBuildings = NO;//显示建筑物
        _mapView.skyModelEnable = NO;//天空模式
        _mapView.rotateEnabled = NO;//是否支持旋转
        _mapView.rotateCameraEnabled = NO; // 不支持旋转
        _mapView.showsCompass = NO;
        _mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);//可见位置
        _mapView.delegate = self;
        _mapView.zoomLevel = 10;//设置缩放级别为0:10千米
        _mapView.minZoomLevel = 6;//
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;


    }
    return _mapView;
}


- (TRZXMapCardCollectionView *)mapCardCollectionView{

    __weak TRZXMapViewController *weakSelf = self;

    if (_mapCardCollectionView == nil) {
        _mapCardCollectionView = [[TRZXMapCardCollectionView alloc]initWithFrame:CGRectMake(0, self.view.height-(MapStockBottomHeight), self.view.height, MapStockBottomHeight)];

        _mapCardCollectionView.mapCardCollectionViewBlock =  ^(TRZXMapAnnotation *annotation) {



        };

        _mapCardCollectionView.scrollViewDidEndDeceleratingPagBlock = ^(NSInteger index){

            TRZXMapUserAnnotationView *annotationView =  (TRZXMapUserAnnotationView *)[weakSelf.mapView viewForAnnotation:weakSelf.currentlist[index]];
            [weakSelf didSelectAnnotationView:annotationView];
            
        };


    }
    return _mapCardCollectionView;
}

- (void)showMapCardCollectionView{

    [UIView animateWithDuration:0.5 animations:^{
            self.mapCardCollectionView.frame = CGRectMake(0, self.view.height-(MapStockBottomHeight), self.view.width, MapStockBottomHeight);
    }];

}
- (void)hiddenMapCardCollectionView{

    [UIView animateWithDuration:0.5 animations:^{
            _mapCardCollectionView.frame = CGRectMake(0, self.view.height, [[UIScreen mainScreen] bounds].size.width, MapStockBottomHeight);
    }];
}


- (UIButton *)centerButton{
    if (!_centerButton) {
        _centerButton = [[UIButton alloc]init];
        [_centerButton setBackgroundImage:[UIImage imageNamed:@"map_location"] forState:UIControlStateNormal];
        _centerButton.adjustsImageWhenDisabled = NO;
        [_centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];


    }
    return _centerButton;
}
- (void)centerButtonClick:(UIButton *)button{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (TRZXMapViewModel *)mapViewModel{

    if (!_mapViewModel) {
        _mapViewModel = [TRZXMapViewModel new];
    }
    return _mapViewModel;
}



- (AMapSearchAPI *)searchApi{
    if (!_searchApi) {

        //初始化检索对象 用于检索行政区域
        _searchApi = [[AMapSearchAPI alloc] init];
        _searchApi.delegate = self;

    }
    return _searchApi;
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{

    if (response.regeocode !=nil )
    {

        NSLog(@"反向地理编码回调city:%@",response.regeocode.addressComponent.city);
        NSLog(@"反向地理编码回调province:%@",response.regeocode.addressComponent.province);

        NSString *latitude = [NSString stringWithFormat:@"%f",request.location.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",request.location.longitude];
        NSString *citycode = response.regeocode.addressComponent.citycode;
        NSString *name = @"";

        if (response.regeocode.addressComponent.city.length>0) {
            name = response.regeocode.addressComponent.city;
        }else{
            name = response.regeocode.addressComponent.province;
        }


        self.mapViewModel.currentCoordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        self.mapViewModel.centerCoordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        self.mapViewModel.citycode = citycode;
        self.mapViewModel.locality = name;

        if (self.mapInitCompleteBlock) {
            self.mapInitCompleteBlock(self.mapViewModel);
        }

        [self requestSignal_list];


    }

}



- (AMapReGeocodeSearchRequest *)searchRequest{
    if (!_searchRequest) {

        _searchRequest = [[AMapReGeocodeSearchRequest alloc] init];
        _searchRequest.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
        _searchRequest.requireExtension =YES;


    }
    return _searchRequest;
}


@end
