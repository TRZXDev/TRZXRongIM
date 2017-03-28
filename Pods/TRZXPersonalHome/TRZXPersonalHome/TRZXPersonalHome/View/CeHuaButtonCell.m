//
//  CeHuaButtonCell.m
//  TRZX
//
//  Created by 张江威 on 16/6/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "CeHuaButtonCell.h"

@implementation CeHuaButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
//            CeHuaButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CeHuaButtonCell"];
//            if (!cell) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"CeHuaButtonCell" owner:nil options:nil]lastObject];
//            }
//
//            if ([_PersonalMode.userType isEqualToString:@"User"]) {
//                cell.ZXView.hidden = YES;
//                cell.OtherView.hidden = YES;
//                [cell.PkechengBtn addTarget:self action:@selector(guankanClick:) forControlEvents:UIControlEventTouchUpInside];
//            }else if([_PersonalMode.userType isEqualToString:@"Gov"]||[_PersonalMode.userType isEqualToString:@"TradingCenter"]){
//                cell.putongView.hidden = YES;
//                cell.OtherView.hidden = YES;
//                [cell.ZXguanzhuBtn addTarget:self action:@selector(topGuanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.ZXkechengBtn addTarget:self action:@selector(guankanClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.ZXluyanBtn addTarget:self action:@selector(shipinClick:) forControlEvents:UIControlEventTouchUpInside];
//
//            }else{
//                cell.ZXView.hidden = YES;
//                cell.putongView.hidden = YES;
//                [cell.OguanzhuBtn addTarget:self action:@selector(topGuanzhuClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.OkechengBtn addTarget:self action:@selector(guankanClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.OluyanBtn addTarget:self action:@selector(shipinClick:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.OrunsangBtn addTarget:self action:@selector(runsangClick:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            cell.OguanzhuLab.text = _PersonalMode.followCount;
//            cell.OkechengLab.text = _PersonalMode.seeUserCount;
//            if (_PersonalMode.roadSeeCount.length == 0) {
//                cell.OluyanLab.text = @"0";
//            }else{
//                cell.OluyanLab.text = _PersonalMode.roadSeeCount;//观看路演
//            }
//            cell.ZXguanzhuLab.text = _PersonalMode.followCount;
//            cell.ZXkechengLab.text = _PersonalMode.seeUserCount;
//            if (_PersonalMode.roadSeeCount.length == 0) {
//                cell.ZXluyanLab.text = @"0";
//            }else{
//                cell.ZXluyanLab.text = _PersonalMode.roadSeeCount;//观看路演
//            }
//            cell.OrunsangLab.text = _PersonalMode.sangCount;
//            cell.PkechengLab.text = _PersonalMode.seeUserCount;
//            cell.PrunsangLab.text = _PersonalMode.sangCount;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            return cell;