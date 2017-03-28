//
//  EOWalletBankCardTableViewCell.h
//  EmployeesOnline
//
//  Created by Rhino on 16/6/17.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EOBankModel;

@interface EOWalletBankCardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cardBgView;
@property (weak, nonatomic) IBOutlet UIImageView *cardPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberlabel;


@property (nonatomic,strong)EOBankModel *model;

@end
