//
//  EOWalletModel.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/22.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  银行卡
 */
@interface EOBankModel : NSObject

@property (copy, nonatomic)NSString *remarks;
@property (copy, nonatomic)NSString *createDate;
@property (copy, nonatomic)NSString *updateDate;
@property (copy, nonatomic)NSString *certifTp;
@property (copy, nonatomic)NSString *accNo;//卡号
@property (copy, nonatomic)NSString *mid;//银行卡id
@property (copy, nonatomic)NSString *bankLogo;//

/**
 身份证号码
 */
@property (copy, nonatomic)NSString *idCard;
/**
 持卡人姓名
 */
@property (copy, nonatomic)NSString *name;

@property (copy, nonatomic)NSString *value;
@property (copy, nonatomic)NSString *label;
@property (copy, nonatomic)NSString *type;
//@property (copy, nonatomic)NSString *description;
@property (copy, nonatomic)NSString *sort;
@property (copy, nonatomic)NSString *parentId;


@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *cardNo;

@property (nonatomic,copy) NSString *bankName;//银行名称
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *bankImg;
@property (nonatomic,copy) NSString *bankType;

//获取的银行卡信息
@property (nonatomic,copy) NSString *cardType;
@property (nonatomic,copy) NSString *img;  //银行卡图片
@property (nonatomic,copy) NSString *bank;
@property (nonatomic,copy) NSString *stat;
@property (nonatomic,copy) NSString *validated;//是否有效
@property (nonatomic,copy) NSString *repeated;//是否有效


//"cardType" : "DC",
//"img" : "https:\/\/apimg.alipay.com\/combo.png?d=cashier&t=BOC",
//"bankName" : "中国银行",
//"bank" : "BOC",
//"stat" : "ok",
//"validated" : true

@end


/**
 *  我的钱包
 */
@interface EOWalletModel : NSObject


@property (nonatomic, assign) CGFloat amount;

@property (nonatomic, copy) NSString *updateDate;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger disableAmount;

@property (nonatomic, copy) NSString *payPassword;



@end

/**
 *  账单记录
 */
@interface EOWalletRecordModel : NSObject


@property (copy, nonatomic)NSString *createDate;
@property (copy, nonatomic)NSString *updateDate;
@property (copy, nonatomic)NSString *amount;
@property (copy, nonatomic)NSString *balance;
@property (assign, nonatomic)NSInteger type;
@property (copy, nonatomic)NSString *inOut;
@property (copy, nonatomic)NSString *transactionNo;
@property (copy, nonatomic)NSString *orderId;
@property (copy, nonatomic)NSString *status;
@property (copy, nonatomic)NSString *mid;
@property (copy, nonatomic)NSString *abs;

@end
