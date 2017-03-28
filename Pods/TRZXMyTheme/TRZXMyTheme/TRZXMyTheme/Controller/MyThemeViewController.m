//
//  ThemeViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/10.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "MyThemeViewController.h"

#import "ThemeOneCell.h"
#import "ThemeTwoCell.h"
#import "ThemeThreeCell.h"

#import "ChuangJianZhuTiVC.h"

#import "DVSwitch.h"
#import "MyThemeModel.h"
#import "ThemeViewController.h"

#import "TRZXMyThemePch.h"

@interface MyThemeViewController ()<UITableViewDataSource,UITableViewDelegate,plusDelegate,UIScrollViewDelegate,zhuti1Delegate,zhutixqDelegate>;

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic)DVSwitch *switcher;
@property (strong, nonatomic)UIScrollView *SwitchScroll;
@property (strong, nonatomic)MyThemeModel *mode;
@property (strong, nonatomic)NSArray *ostLists;
@property (strong, nonatomic)OneToOneInfoData1 *oneToOneInfoData;

@property (strong, nonatomic)UIButton *createThemeButton;
@property (nonatomic,strong) UIButton *submitButton;



@end

@implementation MyThemeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_oneToOneInfoData == nil) {
        [self loadThemeList_Api];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的主题";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeList_Api) name:NSNotificationTheme object:nil];
    [self jiazaiView];

}
- (void)jiazaiView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGTH(self.view)-48)];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.showsVerticalScrollIndicator = NO;
//    _myTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _myTableView.backgroundColor = backColor;
    [self.view addSubview:_myTableView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGTH(self.view)-48, WIDTH(self.view), 48)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    if (_mode.iosOnline.integerValue) {
        bottomView.hidden = YES;
        //高度先注销了
//        _myTableView.height += 48;
    }

    _SwitchScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 14, 88, 20)];
    _SwitchScroll.contentSize = CGSizeMake(176, 20);
    _SwitchScroll.bounces = NO;
    _SwitchScroll.pagingEnabled = YES;
    _SwitchScroll.showsHorizontalScrollIndicator = NO;
    _SwitchScroll.scrollEnabled = YES;
    _SwitchScroll.delegate = self;
    //    _SwitchScroll.layer.cornerRadius = 10;
    [bottomView addSubview:_SwitchScroll];
    
    _createThemeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, 9, 100, 30)];
    [_createThemeButton setImage:[UIImage Theme_loadImage:@"Themejia" class:[self class]] forState:UIControlStateNormal];
    [_createThemeButton setTitle:@"创建主题" forState:UIControlStateNormal];
    _createThemeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_createThemeButton setTitleColor:heizideColor forState:UIControlStateNormal];
    [_createThemeButton addTarget:self action:@selector(plusTheme) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_createThemeButton];
    
    UIImageView *kaiIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(_SwitchScroll), HEIGTH(_SwitchScroll))];
    kaiIV.image = [UIImage Theme_loadImage:@"Themekai" class:[self class]];
    kaiIV.userInteractionEnabled = YES;
    kaiIV.tag = 10000;
    UILabel *kaiLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68, 20)];
    kaiLable.text = @"开放约见";
    kaiLable.font = [UIFont systemFontOfSize:12];
    kaiLable.textColor = [UIColor whiteColor];
    kaiLable.textAlignment = NSTextAlignmentCenter;
    [kaiIV addSubview:kaiLable];
    UITapGestureRecognizer *kaiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchTap:)];
    [kaiIV addGestureRecognizer:kaiTap];
    [_SwitchScroll addSubview:kaiIV];
    
    UIImageView *guanIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH(_SwitchScroll), 0, WIDTH(_SwitchScroll), HEIGTH(_SwitchScroll))];
    guanIV.userInteractionEnabled = YES;
    guanIV.image = [UIImage Theme_loadImage:@"Themeguan" class:[self class]];
    guanIV.tag = 20000;
    UILabel *guanLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 68, 20)];
    guanLable.text = @"约见关闭";
    guanLable.font = [UIFont systemFontOfSize:12];
    guanLable.textColor = [UIColor whiteColor];
    guanLable.textAlignment = NSTextAlignmentCenter;
    [guanIV addSubview:guanLable];
    UITapGestureRecognizer *guanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwitchTap:)];
    [guanIV addGestureRecognizer:guanTap];
    [_SwitchScroll addSubview:guanIV];
    
    
}
- (void)SwitchTap:(UITapGestureRecognizer *)tap {
    UIImageView *iv = (UIImageView *)tap.view;
    if (iv.tag == 10000) {
        [_SwitchScroll setContentOffset:CGPointMake(88, 0) animated:YES];
    } else {
        [_SwitchScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)switchIsChanged:(UISwitch *)paramSender{
    if([paramSender isOn]){//如果开关状态为ON
    }else{
    }
}
- (void)loadThemeList_Api {
    NSDictionary *params = @{
                            @"requestType":@"OtoSchoolTopic_Api",
                            @"apiType":@"findListBySelf",
                            @"pageNo":@"1"};
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            if ([object[@"status_code"] isEqualToString:@"200"]) {
            
            _mode = [MyThemeModel mj_objectWithKeyValues:object];

            NSDictionary * dataDic =object[@"data"];

            _ostLists=  [OneToOneInfoOstList mj_objectArrayWithKeyValuesArray:dataDic[@"ostList"]];

            _oneToOneInfoData = [OneToOneInfoData1 mj_objectWithKeyValues:object[@"data"]];

            if (_ostLists.count>0) {
                [_createThemeButton setTitle:@"创建新主题" forState:UIControlStateNormal];

            }

            [_myTableView reloadData];
            if (!_mode.data.openMeetSign) {

            } else {
                if ([_mode.data.openMeetSign isEqualToString:@"1"]) {
                    _SwitchScroll.contentOffset = CGPointMake(0, 0);
                } else {
                    _SwitchScroll.contentOffset = CGPointMake(88, 0);
                }
            }

        }

    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_mode.data.ostList.count == 0) {
        return 2;
    } else {
        return _mode.data.ostList.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (IS_IPHONE_4_OR_LESS||IS_IPHONE_5){
            return 316+20;
        } else if (IS_IPHONE_6){
            return 357+20;
        } else {
            return 386+20;
        }
    } else
        return 320;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellID = @"CellID";
        ThemeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ThemeOneCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        if ([_mode.data.defaultPic isEqualToString:@"1"]) {//展位图
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:_mode.data.headImg] placeholderImage:[UIImage Theme_loadImage:@"展位图" class:[self class]]];
        }        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:_mode.data.expertPhoto] placeholderImage:[UIImage Theme_loadImage:@"展位图" class:[self class]]];
        cell.nameLable.text = _mode.data.realName;

        cell.nameLable.shadowColor = heizideColor;
        cell.nameLable.shadowOffset = CGSizeMake(0, 0.7);

        if(_mode.data.company.length>0){
            cell.companyLable.text = [NSString stringWithFormat:@"%@,%@ ",_mode.data.company==nil?@"":_mode.data.company,_mode.data.position==nil?@"":_mode.data.position];

        }else{
            cell.companyLable.text = @"";

        }

        cell.cityLable.text = _mode.data.city;
        cell.areaLable.text = [NSString stringWithFormat:@"%@;%@",_mode.data.city,_mode.data.area];
        cell.peopleLable.text = [NSString stringWithFormat:@"%@人",_mode.data.meetCount==nil?@"":_mode.data.meetCount];
        cell.contentView.backgroundColor = backColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *CellID = @"CellID";
        ThemeTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ThemeTwoCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.PriceLable.layer.cornerRadius = 10;
        cell.TimeLongLable.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.jiageciLabel.text = @"/次 ";
        //投融小秘的先屏蔽
        
//        cell.jinqianView.hidden = [[KPOUserDefaults mobile] isEqualToString:@"trzx"]?YES:NO;
        cell.contentView.backgroundColor = backColor;
        if (!_mode.data.ostList.count) {
            cell.ThemeTitle.text = @"主题样例";
            cell.ztylImageView.hidden = YES;
            cell.dianjiView.userInteractionEnabled = YES;
            UITapGestureRecognizer * singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xiugaiClick:)];
            [cell.dianjiView addGestureRecognizer:singleTap1];
            cell.dianjiView.layer.cornerRadius = 10;
            cell.dianjiView.layer.borderWidth = 0.8;
            cell.dianjiView.layer.masksToBounds = YES;
            cell.dianjiView.layer.borderColor = [[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1] CGColor];

        } else {
            Ostlist *ostlistMode = [_mode.data.ostList objectAtIndex:indexPath.row-1];
            cell.PriceLable.text = [NSString stringWithFormat:@" %@",ostlistMode.muchOnce];
            
//下面是判断是否是远程视频的（取消了）
            
//            if ([ostlistMode.topicType isEqualToString:@"1"]) {
//                cell.yuanchengView.hidden = NO;
//            }else{
//                cell.yuanchengView.hidden = YES;
//            }

            cell.jiageciLabel.text = @"元/次 ";
            cell.biaoTiLable.text = ostlistMode.topicTitle;
            cell.TimeLongLable.text = [NSString stringWithFormat:@"约%@",ostlistMode.timeOnce];
            cell.neiRongLabel.text = ostlistMode.topicContent;

            if (ostlistMode.topicTitle.length>0) {
                cell.ThemeTitle.hidden = YES;
            }
            cell.biaoTiLable.text = ostlistMode.topicTitle;
            cell.neiRongLabel.text = ostlistMode.topicContent;
            if(ostlistMode.topicContent.length>0){
                cell.dianjiView.layer.borderColor = [[UIColor clearColor] CGColor];
            }
            cell.ShenHeTitle.hidden = YES;
            cell.ShenHeZhuanTai.hidden = YES;
            cell.yifaBu.hidden = YES;
            cell.sheHeWeiTG.hidden = YES;
//            if ([ostlistMode.auditStatus isEqualToString:@"1"]) {
//                cell.ShenHeTitle.hidden = NO;
//                cell.ShenHeZhuanTai.hidden = NO;
//            }else if ([ostlistMode.auditStatus isEqualToString:@"2"]) {
//                cell.ShenHeTitle.hidden = NO;
//                cell.yifaBu.hidden = NO;
//            }else if ([ostlistMode.auditStatus isEqualToString:@"3"]) {
//                cell.ShenHeTitle.hidden = NO;
//                cell.sheHeWeiTG.hidden = NO;
//            }

        }

        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

    } else {

        if (!_mode.data.ostList.count) {
//            _XiuGaiZhuTi = [[ChuangJianZhuTiVC alloc] init];
//            _XiuGaiZhuTi.delegate = self;
//            [self.navigationController pushViewController:_XiuGaiZhuTi animated:YES];
        } else {
//            Ostlist *ostlistMode = [_mode.data.ostList objectAtIndex:indexPath.row-1];
//            if ([ostlistMode.auditStatus isEqualToString:@"1"]) {
//
//            } else if ([ostlistMode.auditStatus isEqualToString:@"2"]) {

            OneToOneInfoOstList *ostlistMode = [_ostLists objectAtIndex:indexPath.row-1];

            _themeDetails = [[ThemeViewController alloc] init];
            _themeDetails.data = _oneToOneInfoData;
            _themeDetails.ostlistModel = ostlistMode;
            _themeDetails.titleStr = @"主题详情";

            _themeDetails.themeID = ostlistMode.mid;
            _themeDetails.topic = ostlistMode.topicTitle;
            _themeDetails.pricea = ostlistMode.muchOnce;
            if ([ostlistMode.topicType isEqualToString:@"0"])
            {
                _themeDetails.yuancehng = @"线下咨询";
            }else{
                _themeDetails.yuancehng = @"线上咨询";
            }
            _themeDetails.fenleiStr = [NSString stringWithFormat:@"%@-%@",ostlistMode.oneAreaStr,ostlistMode.twoAreaStr];//分类
            _themeDetails.duration = ostlistMode.timeOnce;
            _themeDetails.abstracts = ostlistMode.topicContent;
            _themeDetails.yuanYinStr = ostlistMode.auditOpinion;
            _themeDetails.epId = ostlistMode.epId;
            _themeDetails.oneAreaId = ostlistMode.oneAreaId;
            _themeDetails.twoAreaId = ostlistMode.twoAreaId;
            _themeDetails.delegate = self;
            [self.navigationController pushViewController:_themeDetails animated:YES];
//            } else if ([ostlistMode.auditStatus isEqualToString:@"3"]){
//                _themeNoPass = [[ThemeNoPassController alloc] init];
//                _themeNoPass.themeID = ostlistMode.mid;
//                _themeNoPass.topic = ostlistMode.topicTitle;
//                _themeNoPass.pricea = ostlistMode.muchOnce;
//                if ([ostlistMode.topicType isEqualToString:@"0"])
//                {
//                    _themeNoPass.yuancehng = @"线下咨询";
//                }else{
//                    _themeNoPass.yuancehng = @"线上咨询";
//                }
//                _themeNoPass.duration = ostlistMode.timeOnce;
//                _themeNoPass.abstracts = ostlistMode.topicContent;
//                _themeNoPass.yuanYinStr = ostlistMode.auditOpinion;
//                _themeNoPass.epId = ostlistMode.epId;
//                _themeNoPass.oneAreaId = ostlistMode.oneAreaId;
//                _themeNoPass.twoAreaId = ostlistMode.twoAreaId;
//
//
//                //                _themeNoPass.themeType =
//                [self.navigationController pushViewController:_themeNoPass animated:YES];
//            }

        }
    }
}



#pragma +号代理

- (void)plusTheme
{
    _XiuGaiZhuTi = [[ChuangJianZhuTiVC alloc] init];
    _XiuGaiZhuTi.wumobanStr = @"1";
    _XiuGaiZhuTi.delegate = self;
    [self.navigationController pushViewController:_XiuGaiZhuTi animated:YES];

}

- (void)xiugaiClick:(UITapGestureRecognizer *)sender
{
//默认的一对一详情
    
    
}

- (void)pushZhuTiDe
{
    [self loadThemeList_Api];
}
- (void)pushZhuTiXiangQing
{
    [self loadThemeList_Api];
}

////视图在滚动的时候会被一直调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView.contentOffset滚动视图的偏移量
    if (scrollView == _SwitchScroll) {
        CGPoint p = scrollView.contentOffset;

        if (p.x == 0) {
            
            NSDictionary *params = @{@"equipment":@"ios",
                                  @"requestType":@"OtoSchoolTopic_Api",
                                  @"apiType":@"updateTopicMeet",
                                  @"meetSign":@"1"
                                  };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {

                
            }];

        }

        if (p.x == 88) {
            NSDictionary *params = @{@"equipment":@"ios",
                                  @"requestType":@"OtoSchoolTopic_Api",
                                  @"apiType":@"updateTopicMeet",
                                  @"meetSign":@"2"
                                  };

            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {

                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
