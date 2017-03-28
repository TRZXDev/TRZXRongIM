//
//  RCNewLocationViewController.m
//  TRZX
//
//  Created by 移动微 on 16/6/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCNewLocationViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDCommonDefine.h"
#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapURLSearchConfig.h>
#import <AMapFoundationKit/AMapURLSearch.h>


@interface RCNewLocationViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>

@end

@implementation RCNewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:1]];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {

        [self addFooterView];
    }
}
//-(void)addBackItem{
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 8, 50, 23);
//    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"返回白"]];
//    backImg.frame = CGRectMake(-5, 3, 10, 16);
//    [backBtn addSubview:backImg];
//    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, 85, 22)];
//    backText.text = @"返回";
//    backText.font = [UIFont systemFontOfSize:16];//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
//    [backText setTextColor:[UIColor whiteColor]];
//    [backBtn addSubview:backText];
//    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
//}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addFooterView{

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, RC_SCREEN_HEIGHT - 60, RC_SCREEN_WIDTH, 60)];
    
    footerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footerView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 20, 200)];
    label.text = @"[ 位置 ]";
    label.font = [UIFont systemFontOfSize:20];
    [label sizeToFit];
    [footerView addSubview:label];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(RC_SCREEN_WIDTH - 50 - 20, 5, 50, 50)];
    [button setImage:[UIImage imageNamed:@"RCDRoad"] forState:UIControlStateNormal];
    [footerView addSubview:button];
    [button addTarget:self action:@selector(showMapAlert) forControlEvents:UIControlEventTouchUpInside];
}


-(void)showMapAlert{
    

    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"高德地图", nil];
    
    [sheet showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (buttonIndex) {
        case 0:{
            //高德地图
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择出行方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"驾车",@"公交",@"步行", nil];
            
            [alert show];

            
        }
            break;
        default:
            break;
    }
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    AMapRouteConfig *confige = [[AMapRouteConfig alloc]init];
    confige.appName = [self getApplicationName];
    confige.appScheme = @"cfa78105d94309d4e6d7e74b83939ab5";
    // 投融地图
//    confige.startCoordinate = [KipoUpLocationManage sharedManager].curLocation;
    confige.destinationCoordinate = self.location;
    switch (buttonIndex) {
        case 0:{
            return;
        }
            break;
        case 1:{
        
            confige.routeType = AMapRouteSearchTypeDriving;
            
        }
            break;
        case 2:{
            confige.routeType = AMapRouteSearchTypeTransit;
        }
            break;
        case 3:{
            confige.routeType = AMapRouteSearchTypeWalking;
        }
            break;
        default:
            break;
    }
    
    
    
    confige.drivingStrategy = AMapDrivingStrategyShortest;
    confige.transitStrategy = AMapTransitStrategyFastest;
    
    [AMapURLSearch openAMapRouteSearch:confige];
    
}


- (NSString *)getApplicationName
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"] ?: [bundleInfo valueForKey:@"CFBundleName"];
}

- (NSString *)getApplicationScheme
{
    NSDictionary *bundleInfo    = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier  = [[NSBundle mainBundle] bundleIdentifier];
    NSArray *URLTypes           = [bundleInfo valueForKey:@"CFBundleURLTypes"];
    
    NSString *scheme;
    for (NSDictionary *dic in URLTypes)
    {
        NSString *URLName = [dic valueForKey:@"CFBundleURLName"];
        if ([URLName isEqualToString:bundleIdentifier])
        {
            scheme = [[dic valueForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
            break;
        }
    }
    
    return scheme;
}

@end
