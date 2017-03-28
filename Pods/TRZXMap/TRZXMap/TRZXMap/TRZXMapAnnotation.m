//
//  MapUser.m
//  TRZX
//
//  Created by N年後 on 2017/1/4.
//  Copyright © 2017年 Tiancaila. All rights reserved.
//

#import "TRZXMapAnnotation.h"
#import "MJExtension.h"
@implementation TRZXMapAnnotation

/**
 *  当字典转模型完毕时调用
 */
- (void)mj_keyValuesDidFinishConvertingToObject{

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.latitude floatValue],[self.longitude floatValue]);//纬度，经度
    self.coordinate = coordinate;

    CLLocationCoordinate2D locaCoordinate = CLLocationCoordinate2DMake([self.localLatitude floatValue],[self.locaLongitude floatValue]);//纬度，经度
    self.locaCoordinate = locaCoordinate;
}




@end
