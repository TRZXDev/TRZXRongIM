//
//  TRZXPersonalYYSViewController.m
//  TRZX
//
//  Created by 张江威 on 16/9/14.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXPersonalYYSViewController.h"
#import "xihuanTableViewCell.h"
#import "TRZXYYSTYTableViewCell.h"
//#import "FourEditionHeadlineDetailsViewController.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define HEIGTH(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]

@interface TRZXPersonalYYSViewController ()
{
    CGSize size;
}
@property (strong, nonatomic) UITableView * myTableView;
@property (strong, nonatomic) NSString * querenStr;
@property (strong, nonatomic) NSString * neirongStr;

@end

@implementation TRZXPersonalYYSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStr;
    self.view.backgroundColor = backColor;
    UILabel * jjLabel = [[UILabel alloc] init];
    jjLabel.text = @"投融在线是我国首个股权融资全过程服务平台,涵盖投融学院（在线课程、一对一咨询、投融问答、投融工具）、投融市场（三板、四板、板外）、投融社交（投融私信、投融圈、投融直播）三大版块；聚集股东、专家、投资人、券商、交易中心、政府六个角色。\n\n投融在线面向全国4000万企业股东开放，致力于成为国内最大的企业股东线上聚集地；联合券商、律师、会计师、评估师、税务师、投融专家及投资人等资本市场参与方,为企业股东提供学习咨询及更多融资渠道选择。 \n\n投融在线为各参与方提供多边平台服务，整合匹配多方数据资源，利用大数据技术打破了传统投融资领域的信息不对称；使内容生产去中心化，规模化，让资源、利益共享化，形成了一个高效优质的线上投融生态圈，带你走进资本巿场！";
    jjLabel.font = [UIFont systemFontOfSize:17];
    jjLabel.numberOfLines = 0;
    size = [jjLabel sizeThatFits:CGSizeMake(WIDTH(self.view)-60, MAXFLOAT)];
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    _myTableView = [[UITableView alloc] init];
    _myTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.height)- 64);
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = NO;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.backgroundColor = backColor;
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.view.frame.size.width/640*223;
    }else if(indexPath.section == 1){
//        return size.height;
        return 70+self.view.frame.size.width/640*282+10+130;
        
    }else if (indexPath.section == 2){
        return 60;
    }else {
        return 45;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0||indexPath.section == 1) {
        xihuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xihuanTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"xihuanTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.xihuanView.backgroundColor = backColor;
        if (indexPath.section == 0) {
            UIImageView * images = [[UIImageView alloc]init];
            images.image = [UIImage imageNamed:@"cwyys.png"];
            images.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/640*223);
            [cell.xihuanView addSubview:images];
        }else{
            UILabel * tsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 60)];
            tsLabel.adjustsFontSizeToFitWidth = YES;
            tsLabel.text = @"成为合伙人会获得什么";
            tsLabel.font = [UIFont boldSystemFontOfSize:17];
            tsLabel.textColor = TRZXMainColor;
            tsLabel.textAlignment = NSTextAlignmentLeft;
            [cell.xihuanView addSubview:tsLabel];
            
            
            UIImageView * images = [[UIImageView alloc]init];
            images.image = [UIImage imageNamed:@"yyszs2.png"];
            images.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.width/640*282);
            [cell.xihuanView addSubview:images];
            
            
            UILabel * ts2Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 70+self.view.frame.size.width/640*282+10, self.view.frame.size.width-30, 60)];
            ts2Label.adjustsFontSizeToFitWidth = YES;
            ts2Label.text = @"如何成为合伙人";
            ts2Label.font = [UIFont boldSystemFontOfSize:17];
            ts2Label.textColor = TRZXMainColor;
            ts2Label.textAlignment = NSTextAlignmentLeft;
            [cell.xihuanView addSubview:ts2Label];
            
            UILabel * jjLabel = [[UILabel alloc] init];
            jjLabel.text = @"申请成为合伙人 > 提交身份认证资料 > 审核通过";
            jjLabel.frame = CGRectMake(15, 70+self.view.frame.size.width/640*282+10+70, self.view.frame.size.width-30, 50);
            jjLabel.font = [UIFont systemFontOfSize:15];
            jjLabel.textColor = heizideColor;
            jjLabel.numberOfLines = 0;
            jjLabel.textAlignment = NSTextAlignmentLeft;
            [cell.xihuanView addSubview:jjLabel];
//            UILabel * jjLabel = [[UILabel alloc] init];
//            jjLabel.text = @"投融在线是我国首个股权融资全过程服务平台,涵盖投融学院（在线课程、一对一咨询、投融问答、投融工具）、投融市场（三板、四板、板外）、投融社交（投融私信、投融圈、投融直播）三大版块；聚集股东、专家、投资人、券商、交易中心、政府六个角色。\n\n投融在线面向全国4000万企业股东开放，致力于成为国内最大的企业股东线上聚集地；联合券商、律师、会计师、评估师、税务师、投融专家及投资人等资本市场参与方,为企业股东提供学习咨询及更多融资渠道选择。 \n\n投融在线为各参与方提供多边平台服务，整合匹配多方数据资源，利用大数据技术打破了传统投融资领域的信息不对称；使内容生产去中心化，规模化，让资源、利益共享化，形成了一个高效优质的线上投融生态圈，带你走进资本巿场！";
//            jjLabel.frame = CGRectMake(30, 50, self.view.frame.size.width-60, size.height);
//            jjLabel.font = [UIFont systemFontOfSize:17];
//            jjLabel.textColor = heizideColor;
//            jjLabel.numberOfLines = 0;
//            jjLabel.textAlignment = NSTextAlignmentLeft;
//            [cell.xihuanView addSubview:jjLabel];
        }
        return cell;
    }else if (indexPath.section == 2){
        TRZXYYSTYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXYYSTYTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"TRZXYYSTYTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = backColor;
        [cell.querenBTN addTarget:self action:@selector(querenClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.chakanBtn addTarget:self action:@selector(chakanClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([_querenStr isEqualToString:@"1"]) {
            cell.querenBTN.selected = YES;
        }else{
            cell.querenBTN.selected = NO;
        }
        return cell;
    }else{
        xihuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xihuanTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"xihuanTableViewCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_querenStr isEqualToString:@"1"]) {
            cell.xihuanView.backgroundColor = TRZXMainColor;
        }else{
            cell.xihuanView.backgroundColor = zideColor;
        }
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
        lab.textColor = [UIColor whiteColor];
        lab.text = @"成为合伙人";
        lab.textAlignment = NSTextAlignmentCenter;
        [cell.xihuanView addSubview:lab];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self jianpanyincang];
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        if ([_querenStr isEqualToString:@"1"]) {
            
            NSDictionary *params = @{@"requestType":@"authApi",
                                    @"apiType":@"oneKeyAuth"
                                    };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
                
                if ([data[@"status_code"] isEqualToString:@"200"]) {
                    
                    [self.delegate pushAllSetting];
                    [[self navigationController] popViewControllerAnimated:YES];
                    
                }else{
                    
                }
                
            }];
            
        }
        
    }
}
//查看
- (void)chakanClick:(UIButton *)sender{
//    FourEditionHeadlineDetailsViewController * xieyiVC = [[FourEditionHeadlineDetailsViewController alloc]init];
//    xieyiVC.jieshaoStr = @"合伙人协议";
//    [self.navigationController pushViewController:xieyiVC animated:true];
}
//确认
- (void)querenClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _querenStr = @"1";
    }else{
        _querenStr = @"0";
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
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
