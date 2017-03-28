//
//  RCDFriendInvitationTableViewCell.m
//  RCloudMessage
//
//  Created by litao on 15/7/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDFriendInvitationTableViewCell.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
 

@interface RCDFriendInvitationTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
@property (weak, nonatomic) IBOutlet UIView *additionInfo;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;


@end

@implementation RCDFriendInvitationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onAgree:(id)sender {

    __weak __typeof(self)weakSelf = self;
    
    RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)weakSelf.model.content;
    if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId .length ==0) {
        return;
    }
}

- (void)setModel:(RCMessage *)model {
    _model = model;
    if (![model.content isMemberOfClass:[RCContactNotificationMessage class]])
    {
        return;
    }
    RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.content;
    self.message.text = _contactNotificationMsg.message;
    if (_contactNotificationMsg.sourceUserId == nil || _contactNotificationMsg.sourceUserId.length == 0) {
        return;
    }
    NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
    if (_cache_userinfo) {
        self.userName.text = _cache_userinfo[@"username"];
        [self.portrait sd_setImageWithURL:[NSURL URLWithString:_cache_userinfo[@"portraitUri"]] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    } else {
        self.userName.text = [NSString stringWithFormat:@"user<%@>", _contactNotificationMsg.sourceUserId];
        [self.portrait setImage:[UIImage imageNamed:@"icon_person"]];
    }


}
@end
