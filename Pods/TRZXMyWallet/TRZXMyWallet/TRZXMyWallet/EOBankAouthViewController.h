//
//  EOBankAouthViewController.h
//  TRZX
//
//  Created by Rhino on 2016/11/18.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WalletBaseViewController.h"
@class EOBankModel;
@interface EOBankAouthViewController : WalletBaseViewController

@property (nonatomic,copy)NSString *bankNumber;

@property (nonatomic, strong)EOBankModel *model;

@end
