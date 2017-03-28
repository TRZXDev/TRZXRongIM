//
//  RCDPublicServiceChatViewController.m
//  TRZX
//
//  Created by 移动微 on 16/11/15.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "RCDPublicServiceChatViewController.h"
#import "RCDPublicServiceProfileViewController.h"
#import "RCDCollectionMessage.h"
#import "RCDPublicMessage.h"
#import "RCDBusinessCardMessage.h"
#import "RCDSelectPersonViewController.h"
#import "RCDPublicWebViewController.h"
#import "RCDCommonDefine.h"
#import "UIBarButtonItem+RCExtension.h"
#import "UIView+RCExtension.h"
#import "NSNumber+RCExtension.h"
#import "UIImageView+WebCache.h"
#import <TRZXKit/UIColor+APP.h>
#import <TRZXKit/UIView+TRZX.h>

@interface RCDPublicServiceChatViewController ()

@property(nonatomic,strong) RCPublicServiceProfile *profile;

@end

@implementation RCDPublicServiceChatViewController{
    RCMessageModel *globalMessModel;
    UIImageView *RecordTouthImage;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem RC_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:[UIColor trzx_TextColor] action:@selector(leftBarButtonItemPressed:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem RC_RightButtonItemWithImageName:@"RCDPublicChat_rightButtonItem" buttonRect:CGRectMake(0, 0, 60, 50) imageRect:CGRectMake(40, 15, 20, 20) Target:self action:@selector(rightBarButtonItemPressed:)];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    [[RCIMClient sharedRCIMClient] getPublicServiceProfile:self.targetId conversationType:ConversationType_PUBLICSERVICE onSuccess:^(RCPublicServiceProfile *serviceProfile) {
        
        self.profile = serviceProfile;
        self.targetId = serviceProfile.publicServiceId;
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlPubType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
        self.chatSessionInputBarControl.publicServiceMenu = serviceProfile.menu;

        for (RCPublicServiceMenuItem *item in serviceProfile.menu.menuItems) {
            NSLog(@">>>>>>>>>>>>%@",item.name);
        }
    } onError:^(NSError *error) {
        
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuControllerWillHideMenu) name:UIMenuControllerWillHideMenuNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)leftBarButtonItemPressed:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonItemPressed:(UIButton *)button{
    RCDPublicServiceProfileViewController *serviceProfileVC = [[RCDPublicServiceProfileViewController alloc] init];
    [serviceProfileVC setClearHistoryMessage:^{
        if (self.conversationDataRepository.count) {
            NSMutableArray *temp = [self.conversationDataRepository mutableCopy];
            for (RCMessageModel *model in temp) {
                [self deleteMessage:model];
            }
            [self.conversationMessageCollectionView reloadData];
        }
    }];
    serviceProfileVC.profile = self.profile;
    [self.navigationController pushViewController:serviceProfileVC animated:YES];
}

#pragma mark - 点击工具栏
-(void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor trzx_TitleColor];
//    UIFont *font = [UIFont boldSystemFontOfSize:19.f];
//    NSDictionary *textAttributes = @{
//                                     NSFontAttributeName : font,
//                                     NSForegroundColorAttributeName :[UIColor trzx_RedColor]
//                                     };
//    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
//    [[UINavigationBar appearance] setTintColor:[UIColor trzx_TextColor]];
    
}

- (void)onPublicServiceMenuItemSelected:(RCPublicServiceMenuItem *)selectedMenuItem{
//    [super onPublicServiceMenuItemSelected:selectedMenuItem];

    // 测试注释
//    UIViewController *webVC = [[CTMediator sharedInstance] webViewControllerWithWebURL:selectedMenuItem.url];
//    [self.navigationController pushViewController:webVC animated:true];

}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell isKindOfClass:NSClassFromString([NSString stringWithFormat:@"RCPublicServiceImgTxtMsgCell"])]) {
        UIImageView *imageView = [cell valueForKey:@"_arrow"];
        imageView.image = [UIImage imageNamed:@"RCDForwardarrow"];
        imageView.height = 15;
        imageView.width = 10;
    }
}

/**
 长按点击事件
 */
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    if ([model.content isKindOfClass:[RCVoiceMessage class]] ||
        [model.content isKindOfClass:[RCDCollectionMessage class]] ||
        [model.content isKindOfClass:[RCDPublicMessage class]] ||
        [model.content isKindOfClass:[RCDBusinessCardMessage class]] ||
        [model.content isKindOfClass:[RCLocationMessage class]] ){
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *menu1 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteLongPressClick)];
        if(model.messageDirection == MessageDirection_SEND &&
           [[NSNumber numberWithLong:model.sentTime] RC_timeCompareWithInterval:180]){
            UIMenuItem *menu2 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(recallMessageClick)];
            menuController.menuItems = @[menu1,menu2];
        }else{
            menuController.menuItems = @[menu1];
        }
        globalMessModel = model;
        [menuController setMenuVisible:YES animated:YES];
        [menuController setTargetRect:CGRectMake(0, 0, 40, 40) inView:view];
        [menuController update];
        if([model.content isKindOfClass:[RCVoiceMessage class]]){
            [self getTouchImage:view model:model];
        }
    }else{
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        NSMutableArray *temp = [NSMutableArray array];
        UIMenuItem *menu1 = [[UIMenuItem alloc]initWithTitle:@"转发" action:@selector(ForwardLongPressClick)];
        [temp addObject:menu1];
        UIMenuItem *menu2 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(CopyLongPressClick)];
        if ([model.content isKindOfClass:[RCTextMessage class]]) {
            [temp addObject:menu2];
        }
        UIMenuItem *menu3 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteLongPressClick)];
        [temp addObject:menu3];
        
        if(model.messageDirection == MessageDirection_SEND &&
           [[NSNumber numberWithLong:model.sentTime] RC_timeCompareWithInterval:180]){
            UIMenuItem *menu4 = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(recallMessageClick)];
            [temp addObject:menu4];
        }
        menuController.menuItems = [NSArray arrayWithArray:temp];
        globalMessModel = model;
        if ([model.content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *messageModel = (RCImageMessage *)model.content;
            [[[UIImageView alloc]init] sd_setImageWithURL:[NSURL URLWithString:messageModel.imageUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                messageModel.originalImage = image;
            }];
        }
        [menuController setMenuVisible:YES animated:YES];
        [menuController setTargetRect:CGRectMake(0, 0, 40, 40) inView:view];
        [menuController update];
        
        if ([model.content isKindOfClass:[RCTextMessage class]]) {
            [self getTouchImage:view model:model];
        }
    }
}

-(void)getTouchImage:(UIView *)view model:(RCMessageModel *)model{
    
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *touthView = (UIImageView *)view;
        if (model.messageDirection == MessageDirection_SEND) {
            UIImage *image = touthView.image;
            UIImage * img= [UIImage RC_BundleImgName:@"RCDChat_to_bg_highlighted"];
            img = [img stretchableImageWithLeftCapWidth:image.leftCapWidth topCapHeight:image.topCapHeight];
            touthView.highlightedImage = img;
        }else{
            UIImage *image = touthView.image;
            UIImage * img= [UIImage RC_BundleImgName:@"RCDChat_from_bg_highlighted"];
            img = [img stretchableImageWithLeftCapWidth:image.leftCapWidth topCapHeight:image.topCapHeight];
            touthView.highlightedImage = img;
        }
        touthView.highlighted = YES;
        RecordTouthImage = touthView;
    }
}

-(void)deleteLongPressClick{
    
    [self deleteMessage:globalMessModel];
}

-(void)recallMessageClick{
    [self recallMessage:globalMessModel.messageId];
}
-(void)ForwardLongPressClick{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"RongIM" bundle:nil];
    RCDSelectPersonViewController *selectPersonVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDSelectPersonViewController"];
    selectPersonVC.forwardMessage = globalMessModel;
    [self.navigationController pushViewController:selectPersonVC animated:YES];
}
#pragma mark - 复制 粘贴
-(void)CopyLongPressClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if ([globalMessModel.content isKindOfClass:[RCImageMessage class]]) {
        RCImageMessage *imageMessage = (RCImageMessage *)globalMessModel.content;
        pasteboard.image = imageMessage.thumbnailImage;
    }
    
    if ([globalMessModel.content isKindOfClass:[RCTextMessage class]]) {
        RCTextMessage *text = (RCTextMessage *)globalMessModel.content;
        pasteboard.string = text.content;
    }
}

-(void)menuControllerWillHideMenu{
    
    if (RecordTouthImage) {
        
        RecordTouthImage.highlighted = NO;
        
        RecordTouthImage = nil;
    }
}

-(void)didTapUrlInPublicServiceMessageCell:(NSString *)url model:(RCMessageModel *)model{
    
    NSLog(@"%@",model);
    RCDPublicWebViewController *publicWebView = [[RCDPublicWebViewController alloc] init];
    publicWebView.profile = self.profile;
    if ([model.content isKindOfClass:[RCPublicServiceRichContentMessage class]]) {
        publicWebView.desc = ((RCPublicServiceRichContentMessage *)model.content).richConent.digest;
        publicWebView.headURL = ((RCPublicServiceRichContentMessage *)model.content).richConent.imageURL;
    }
    publicWebView.webURL = url;
    [self.navigationController pushViewController:publicWebView animated:true];
}

@end
