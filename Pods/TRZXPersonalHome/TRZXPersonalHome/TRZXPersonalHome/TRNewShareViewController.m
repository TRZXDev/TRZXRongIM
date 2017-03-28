//
//  TRNewShareViewController.m
//  TRZX
//
//  Created by Rhino on 16/9/1.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRNewShareViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "UIImageView+WebCache.h"
#import <TRZXLogin/Login.h>
#import "TRZRHShowUserHeader.h"


//#import "PPGetAddressBook.h"
//#import "RHShowUserHeader.h"

#define buttonTag 4444
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



@interface TRNewShareViewController ()<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (copy,nonatomic)NSString *shareText;

// //////// //////////////////约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;

@end

@implementation TRNewShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backColor;
    
    if (IS_IPHONE_4_OR_LESS||IS_IPHONE_5){
        self.topLayout.constant = 80;
        self.leftMarginLayout.constant = 20;
        self.rightMarginLayout.constant = 20;
        self.widthLayout.constant = 150;
    }
    self.title = @"邀请好友";
    [self.shareImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"图标-2"]];
    self.shareImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareImageClick:)];
    [self.shareImage addGestureRecognizer:tap];
    
    //不知道的先注销了
//   [PPGetAddressBook requestAddressBookAuthorization];
}



- (void)shareImageClick:(UITapGestureRecognizer *)tap{
    TRZRHShowUserHeader *show =  [[TRZRHShowUserHeader alloc]init];
    [self.view addSubview:show];
    [show showFromView:self.shareImage withImage:self.shareImage.image];

}

- (IBAction)shareButtonClick:(id)sender {
        UIButton *button = (UIButton *)sender;
        NSInteger index = button.tag - buttonTag;


    if (index == 0) {
        //通讯录
        [self addContact];
        return;
    }
    //分享的先注销了


//    NSString *title= @"投融在线-带您走进资本市场";
//    NSString *desc= @"股权融资全过程服务第三方平台，提高融资能力，获取融资渠道！";
//    NSString * link= self.smsUrl;
//    UIImage *testImage = _shareImage.image;

    
//    OSMessage *msg=[[OSMessage alloc]init];
//    msg.title= title;
//    msg.desc= desc;
//    msg.link= link;
//    msg.image=testImage;//缩略图
//
//    [[Kipo_ShareManager sharedManager]showInvitationMessage:msg index:index];


}

//邀请好友
- (void)addContact
{
    NSString *shareText = [NSString stringWithFormat:@"【投融在线】你的朋友%@在投融在线请求加你为好友，赶快去处理吧！%@",[Login curLoginUser].name,self.smsInviteUrl];//
    NSString *strUrling = [shareText stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strUrl = [strUrling stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [self sendMessageWithPhone:nil andText:strUrl];
    
}

#pragma mark - 发送短信
- (void)sendMessageWithPhone:(NSString *)phone andText:(NSString *)text
{
    //如果能发送文本信息
    if([MFMessageComposeViewController canSendText]){
        MFMessageComposeViewController *messageController=[[MFMessageComposeViewController alloc]init];
        //收件人
        //信息正文
        messageController.body = text;
        //设置代理,注意这里不是delegate而是messageComposeDelegate
        messageController.messageComposeDelegate = self;
        messageController.delegate = self;
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

#pragma mark - MFMessageComposeViewController代理方法
//发送完成，不管成功与否
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultSent:
            //转圈先注销了
//            [LCProgressHUD showInfoMsg:@"邀请成功"];
            
            break;
        case MessageComposeResultCancelled:

            break;
        default:

            break;
    }
    
}

- (void)delayMethod{
    //转圈先注销了
//    [LCProgressHUD showSuccess:@"邀请成功"];
}

//不知道干嘛的  先注销了
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
