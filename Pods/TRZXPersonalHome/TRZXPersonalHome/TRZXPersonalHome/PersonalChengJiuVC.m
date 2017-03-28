//
//  PersonalChengJiuVC.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/12.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "PersonalChengJiuVC.h"
#import "PersonalChengJiuCell.h"
#import "TRZPersonalModell.h"
#import "PersonalCJXMCell.h"
#import "PersonaljiaoyiCell.h"

#import "MJRefresh.h"
#import "MJExtension.h"
#import "TRZXNetwork.h"
#import "UIImageView+WebCache.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define moneyColor [UIColor colorWithRed:209.0/255.0 green:187.0/255.0 blue:114.0/255.0 alpha:1]


@interface PersonalChengJiuVC ()

@property (nonatomic, strong) NSString * oneLabStr;
@property (nonatomic, strong) NSString * twoLabStr;
@property (strong, nonatomic) TRZPersonalModell *PersonalMode;
@property (strong, nonatomic) NSMutableArray * personalArr;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;
@property (strong, nonatomic) UILabel *noLabelView;
@property (nonatomic, strong) UIImageView * bgdImage;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray * ProvArr;


@end


@implementation PersonalChengJiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleStrr;
    [self.view addSubview:self.bgdImage];
    _bgdImage.hidden = YES;
    self.view.backgroundColor = backColor;
    _oneLabStr = @"[一对一咨询]";
    _twoLabStr = @"靠谱投融股权投资服务公司";
    _pageNo = 1;
    
    [self createUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.tableView.mj_footer.hidden = NO;
        _noLabelView.hidden = YES;
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:_pageNo refresh:1];
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            _tableView.tableFooterView = self.noLabelView;
            _noLabelView.hidden = NO;
            _tableView.mj_footer.hidden = YES;
        }
    }];
    self.tableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    NSDictionary *params = @{@"requestType":@"UserHomePage_Api",
                            @"apiType":@"findAchievements",
                             @"id":_midStrr?_midStrr:@"",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                            };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        if ([object[@"status_code"] isEqualToString:@"200"]) {
            
            NSDictionary *personalDic = object[@"data"];
            _totalPage = [object[@"totalPage"] integerValue];
            if(refreshIndex==0){
                _personalArr = [[NSMutableArray alloc]initWithArray:[TRZPersonalModell mj_objectArrayWithKeyValuesArray:personalDic]];
                if (_personalArr.count>0) {
                    self.tableView.tableFooterView = [[UIView alloc]init];
                    self.tableView.mj_footer.hidden = NO;
                    self.tableView.backgroundColor = backColor;
                    self.bgdImage.hidden = YES;
                    if(_totalPage<=1){
                        self.tableView.tableFooterView = self.noLabelView;
                        _noLabelView.hidden = NO;
                        self.tableView.mj_footer.hidden = YES;
                    }else{
                        self.tableView.mj_footer.hidden = NO;
                        self.tableView.tableFooterView.hidden = YES;
                    }
                }else{
                    self.tableView.mj_footer.hidden = YES;
                    self.tableView.backgroundColor = [UIColor clearColor];
                    self.bgdImage.hidden = NO;
                }
                [self.tableView.mj_header endRefreshing];
            }else{
                NSArray *array = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:personalDic];
                if (array.count>0) {
                    [_personalArr addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                    
                }else{
                    _bgdImage.hidden = NO;
                    self.tableView.mj_footer.hidden = YES;
                }
            }
            [self.tableView reloadData];
        }else{
            self.tableView.mj_footer.hidden = YES;
            self.tableView.backgroundColor = [UIColor clearColor];
            _bgdImage.hidden = NO;
            
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)createUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, (self.view.frame.size.height)- 74)];
    self.tableView.separatorStyle = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = backColor;
//    _noLabelView = [[[NSBundle mainBundle]loadNibNamed:@"NoLabelView" owner:self options:nil] objectAtIndex:0];
//    _noLabelView.backgroundColor = backColor;
//    _noLabelView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personalArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZPersonalModell *mode = [_personalArr objectAtIndex:indexPath.row];
    if ([mode.dataModelType isEqualToString:@"GovRoadShow"]||[mode.dataModelType isEqualToString:@"TradingCenter"]){
        return 100;
    }else{
        return 130;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZPersonalModell *mode = [_personalArr objectAtIndex:indexPath.row];

    if ([mode.dataModelType isEqualToString:@"Projectz"]||[mode.dataModelType isEqualToString:@"RoadShow"]) {//项目
        PersonalCJXMCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCJXMCell"];
        if (!cell) {
            cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"PersonalCJXMCell" owner:self options:nil] lastObject];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = backColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([mode.dataModelType isEqualToString:@"Projectz"]){
            _oneLabStr = @"[项目]";
        }else{
            _oneLabStr = @"[路演]";
        }
        _twoLabStr = mode.name;
        cell.suoshuLabel.text = mode.tradeInfo;
        cell.neirongLabel.text = [NSString stringWithFormat:@"  %@",mode.briefIntroduction];
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.logo]placeholderImage:[UIImage imageNamed:@"展位图"]];
        NSString * str = [NSString stringWithFormat:@"%@ %@",_oneLabStr,_twoLabStr];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:_oneLabStr];
        [hintString addAttribute:NSForegroundColorAttributeName value:moneyColor range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:_twoLabStr];
        [hintString addAttribute:NSForegroundColorAttributeName value:heizideColor range:range2];
        cell.titleLabel.attributedText=hintString;
        return cell;
    } else if ([mode.dataModelType isEqualToString:@"GovRoadShow"]||[mode.dataModelType isEqualToString:@"TradingCenter"]){
                PersonaljiaoyiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonaljiaoyiCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonaljiaoyiCell" owner:self options:nil] lastObject];
                }
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                cell.backgroundColor = backColor;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _oneLabStr = @"[在线学院]";
                _twoLabStr = mode.name;
               // @"[地方政府说
                cell.neirongLabel.text = mode.user;
                [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.videoImg]placeholderImage:[UIImage imageNamed:@"展位图"]];
                NSString * str = [NSString stringWithFormat:@"%@ %@",_oneLabStr,_twoLabStr];
                NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
                //获取要调整颜色的文字位置,调整颜色
                NSRange range1=[[hintString string]rangeOfString:_oneLabStr];
                [hintString addAttribute:NSForegroundColorAttributeName value:moneyColor range:range1];
        
                NSRange range2=[[hintString string]rangeOfString:_twoLabStr];
                [hintString addAttribute:NSForegroundColorAttributeName value:heizideColor range:range2];
                cell.titleLabel.attributedText=hintString;
                return cell;
            }
//    else if ([mode.dataModelType isEqualToString:@"FinanceCoursez"]||[mode.dataModelType isEqualToString:@"OtoSchoolTopic"]||[mode.dataModelType isEqualToString:@"RoadShow"])
    else{
    PersonalChengJiuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalChengJiuCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalChengJiuCell" owner:self options:nil] lastObject];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = backColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bofangImage.image = [UIImage imageNamed:@"播放1.png"];
    if ([mode.dataModelType isEqualToString:@"videoz"]) {
        _oneLabStr = @"[在线视频]";
        _twoLabStr = mode.topicTitle;
        cell.nameLabel.text = mode.name;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto]placeholderImage:[UIImage imageNamed:@"展位图"]];
       
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.name];
    }else if ([mode.dataModelType isEqualToString:@"FinanceCoursez"]){
        _oneLabStr = @"[在线课程]";
        _twoLabStr = mode.name;
        cell.nameLabel.text = mode.user;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.userPic]placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.position];
    }else if ([mode.dataModelType isEqualToString:@"OtoSchoolTopic"]){
        cell.bofangImage.hidden = YES;
        _oneLabStr = @"[一对一咨询]";
        _twoLabStr = mode.picTitle;
        cell.nameLabel.text = mode.realName;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.expertPhoto]placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.position];
        
    }else if ([mode.dataModelType isEqualToString:@"OnLineSchool"]){
        _oneLabStr = @"[在线学院]";
        _twoLabStr = mode.name;
        cell.nameLabel.text = mode.user;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.userPic]placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.title];
    }else if ([mode.dataModelType isEqualToString:@"TradingCenter"]){
        _oneLabStr = @"[在线学院]";
        _twoLabStr = mode.name;
        cell.nameLabel.hidden = YES;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.videoImg]placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.name];
    }else if ([mode.dataModelType isEqualToString:@"AttractRoadShow"]){
        _oneLabStr = @"[招商路演]";
        _twoLabStr = mode.name;
        cell.nameLabel.hidden = YES;
        [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:mode.videoImg]placeholderImage:[UIImage imageNamed:@"展位图"]];
        cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",mode.company,mode.name];
    }
    
    
    NSString * str = [NSString stringWithFormat:@"%@ %@",_oneLabStr,_twoLabStr];
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:_oneLabStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:moneyColor range:range1];
    
    NSRange range2=[[hintString string]rangeOfString:_twoLabStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:heizideColor range:range2];
    
    cell.titleLabel.attributedText=hintString;
    
    
    return cell;
    }
//
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     TRZPersonalModell *mode = [_personalArr objectAtIndex:indexPath.row];
    if ([mode.dataModelType isEqualToString:@"videoz"]) {
        //@"[在线视频] || //= @"[地方政府说]";
        
    }else if ([mode.dataModelType isEqualToString:@"GovRoadShow"]||[mode.dataModelType isEqualToString:@"TradingCenter"]){
        // @"[在线课程]"

    }else if ([mode.dataModelType isEqualToString:@"FinanceCoursez"]){
        // @"[在线课程]"
        
        
    }else if ([mode.dataModelType isEqualToString:@"OtoSchoolTopic"]){
        // @"[一对一话题]";
        
    }else if ([mode.dataModelType isEqualToString:@"OnLineSchool"]){
        //= @"[在线学院]";
        
    }

else if ([mode.dataModelType isEqualToString:@"AttractRoadShow"]){
        //= @"[招商路演]";
        
    }else if ([mode.dataModelType isEqualToString:@"Projectz"]||[mode.dataModelType isEqualToString:@"RoadShow"]){
        //= @"[项目信息]";
       

    }
}
-(UIImageView *)bgdImage{
    if (!_bgdImage) {
        
        _bgdImage = [[UIImageView alloc]init];
        _bgdImage.image = [UIImage imageNamed:@"列表无内容.png"];
        _bgdImage.frame = CGRectMake(0, (self.view.frame.size.height-self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width);
        
        
    }
    return _bgdImage;
}
- (UILabel *)noLabelView{
    if (!_noLabelView) {
        _noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _noLabelView.text = @"— 没有更多了 —";
        _noLabelView.textAlignment = NSTextAlignmentCenter;
        _noLabelView.textColor = zideColor;
    }
    return _noLabelView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
