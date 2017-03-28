//
//  RCDAddFriendCell.m
//  TRZX
//
//  Created by 移动微 on 16/11/4.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDAddFriendCell.h"
#import "RCDUserInfo.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDCommonDefine.h"


@interface RCDAddFriendCell ()

@end

@implementation RCDAddFriendCell

#pragma mark - Properties
-(void)addButtonDidClick:(UIButton *)button{
    //添加按钮
    if (button.selected) {
        return;
    }
    
    if([self.userInfo.isAlso isEqualToString:@"TimeOut"]){
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"朋友请求已过期，请主动添加好友" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"加为好友", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
            if ([indexNumber intValue] == 1) {
                [[RCDHttpTool shareInstance] requestFriend:self.userInfo.userId complete:^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 融云提示
//                        [LCProgressHUD showMessage:@"验证发送成功"];
                    });
                }];
            }
        }];
    }else{
        button.userInteractionEnabled = NO;
        [[RCDHttpTool shareInstance] processRequestFriend:self.userInfo.friendRelationshipId complete:^(BOOL result) {
            button.userInteractionEnabled = YES;
            if (result) {
                button.selected = YES;
                button.backgroundColor = [UIColor whiteColor];
                [[RCDataBaseManager shareInstance] deleteAddFriendMessage:self.userInfo.friendRelationshipId];
                [[RCDataBaseManager shareInstance] insertFriendToDB:self.userInfo];
            }
        }];
    }
    
}

#pragma mark - Properties
-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton RC_buttonWithTitle:@"同意" color:[UIColor whiteColor] imageName:nil target:self action:@selector(addButtonDidClick:)];
        _addButton.RC_cornerRadius = 6;
        _addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addButton setTitle:@"已添加" forState:UIControlStateSelected];
        [_addButton setTitleColor:[UIColor trzx_TitleColor] forState:UIControlStateSelected];
        [_addButton setBackgroundColor:[UIColor trzx_RedColor]];
        [self.contentView addSubview:_addButton];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(80, 25));
        }];
    }
    return _addButton;
}
-(UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TextColor] fontSize:15 aligment:NSTextAlignmentLeft];
        [self.contentView addSubview:_companyLabel];
        [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.nameLabel);
        }];
    }
    return _companyLabel;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel RC_labelWithTitle:@"" color:[UIColor trzx_TitleColor] fontSize:17 aligment:NSTextAlignmentLeft];
        _nameLabel.numberOfLines = 1;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImage).offset(5);
            make.left.equalTo(self.headImage.mas_right).offset(10);
            make.right.equalTo(self.addButton.mas_left).offset(-5);
        }];
    }
    return _nameLabel;
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.RC_cornerRadius = 6;
        [self.contentView addSubview:_headImage];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageDidClick:)];
        [_headImage addGestureRecognizer:tap];
        [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    }
    return _headImage;
}


/**
 头像点击
 */
- (void)headImageDidClick:(UITapGestureRecognizer *)tap{
    UIViewController *personalHomeVC = [[CTMediator sharedInstance]  personalHomeViewControllerWithOtherStr:@"1" midStrr:self.userInfo.userId];
    if (personalHomeVC) {
        [self.viewController.navigationController  pushViewController:personalHomeVC animated:YES];
    }
}

-(UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView RC_viewWithColor:[UIColor clearColor]];
        [self.contentView addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.height.offset(1);
        }];
    }
    return _separatorView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView RC_viewWithColor:[UIColor clearColor]];
        [self.contentView addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.companyLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return _bottomView;
}

-(void)setUserInfo:(RCDUserInfo *)userInfo{
    _userInfo = userInfo;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage RC_BundleImgName:@"展位图"]];
    self.nameLabel.text = userInfo.name;
    
    NSString *companyStr = @"  ";
    if(userInfo.company.length && userInfo.position.length){
        companyStr = [NSString stringWithFormat:@"%@ , %@",userInfo.company,userInfo.position];
    }
    self.companyLabel.text = companyStr;
    
    if ([userInfo.isAlso isEqualToString:@"Complete"]) {
        self.addButton.selected = YES;
        self.addButton.backgroundColor = [UIColor whiteColor];
    }else{
        self.addButton.selected = NO;
        self.addButton.backgroundColor = [UIColor trzx_RedColor];
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self separatorView];
        [self bottomView];
    }
    return self;
}

@end
