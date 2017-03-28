//
//  UIColor+MACProject
//  MACProject
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "UIColor+APP.h"
#import "UIColor+TRZX.h"

@implementation UIColor(APP)

+(UIColor *)trzx_MainColor{

    return [UIColor trzx_colorWithHexString:@"#323542"];
}
//导航条颜色
+ (UIColor *)trzx_NavigationBarColor{
    return [UIColor trzx_colorWithHexString:@"#FFFFFF"];//#1aa7f2 2da4f6
}

//trzx_蓝色
+ (UIColor *)trzx_BlueColor{
    return [UIColor trzx_colorWithHexString:@"#7687f1"];//099fde
}

//trzx_红色
+ (UIColor *)trzx_RedColor{
    return [UIColor trzx_colorWithHexString:@"#D7000F"];
}

//trzx_黄色
+ (UIColor *)trzx_YellowColor{
    return [UIColor trzx_colorWithHexString:@"#f7ba5b"];
}


//trzx_橙色
+ (UIColor *)trzx_OrangeColor{
    return [UIColor trzx_colorWithHexString:@"#ea6644"];
}

//trzx_绿色
+ (UIColor *)trzx_GreenColor{
    return [UIColor trzx_colorWithHexString:@"#52cbb9"];
}

//trzx_背景色
+ (UIColor *)trzx_BackGroundColor{
    return [UIColor trzx_colorWithHexString:@"#e6e6e6"];
}

//trzx_直线色
+ (UIColor *)trzx_LineColor{
//    return [UIColor colorWithMacHexString:@"#c8c8c8"];
    return [UIColor trzx_colorWithHexString:@"#D6D6D6"];
}
//trzx_导航栏文字颜色
+ (UIColor *)trzx_NavTitleColor{
    return [UIColor trzx_colorWithHexString:@"#525252"];
}
//trzx_标题颜色
+ (UIColor *)trzx_TitleColor{
    return [UIColor trzx_colorWithHexString:@"#474747"];
}

//trzx_文字颜色
+ (UIColor *)trzx_TextColor{
    return [UIColor trzx_colorWithHexString:@"#A0A0A0"];
}

//trzx_浅红颜色
+ (UIColor *)trzx_LightRedColor{
    return [UIColor trzx_colorWithHexString:@"#FFB7C1"];
}

//trzx_输入框颜色
+ (UIColor *)trzx_TextFieldColor{
    return [UIColor trzx_colorWithHexString:@"#FFFFFF"];
}

//trzx_黑色色
+ (UIColor *)trzx_BlackColor{
    return [UIColor trzx_colorWithHexString:@"#333d47" ];
}
/**
 *  trzx_次分割线
 */
+ (UIColor *)trzx_SecondLineColor{
     return [UIColor trzx_colorWithHexString:@"#e5e5e5"];
}

@end
