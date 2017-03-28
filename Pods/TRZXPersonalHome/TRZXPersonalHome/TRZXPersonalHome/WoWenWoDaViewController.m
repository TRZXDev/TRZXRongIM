//
//  WoWenWoDaViewController.m
//  TRZX
//
//  Created by 张江威 on 16/7/22.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "WoWenWoDaViewController.h"
#import "WoWenTableViewCell.h"
#import "TRZPersonalModell.h"

#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "AFHTTPSessionManager.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]
#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]

@interface WoWenWoDaViewController ()



@property (strong, nonatomic) TRZPersonalModell *PersonalMode;
@property (strong, nonatomic) NSMutableArray * personalArr;

@property (strong, nonatomic) NSString * requestTypeStr;
@property (strong, nonatomic) NSString * apiTypeStr;
@property (strong, nonatomic) NSString * pageNoStr;
@property (strong, nonatomic) UILabel *noLabelView;
@property (strong, nonatomic) NSString * wendaStr;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;
@property (strong, nonatomic) NSString * totalCount;
@property (nonatomic, strong) UIImageView * bgdImage;

@end

@implementation WoWenWoDaViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title2Str;
    if ([_titleStrr isEqualToString:@"我的答复"]||[_titleStrr isEqualToString:@"她的答复"]||[_titleStrr isEqualToString:@"他的答复"]) {
        _wendaStr = @"1";
    }else if ([_titleStrr isEqualToString:@"我的问答"]||[_titleStrr isEqualToString:@"他的问答"]||[_titleStrr isEqualToString:@"她的问答"]) {
        _wendaStr = @"0";
    }
    self.view.backgroundColor = backColor;
    _pageNo = 1;
    
    [self createUI];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _tableView.mj_footer.hidden = YES;
        _noLabelView.hidden = YES;
        _pageNo = 1;
        [self createData:_pageNo refresh:0];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            [self createData:_pageNo refresh:1];
            
        }else{
            [_tableView.mj_footer endRefreshing];
           
            self.tableView.tableFooterView = self.noLabelView;
            _noLabelView.hidden = NO;
            _tableView.mj_footer.hidden = YES;
        }
    }];
    _tableView.mj_footer.hidden = YES;
    [self createData:_pageNo refresh:0];
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{

    NSDictionary *params = @{@"requestType":@"Question_Api",
                            @"apiType":@"newMyQuestion",
                            @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo],
                            @"beVisitId":_midStrr?_midStrr:@""
                            };
    
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        if ([object[@"status_code"] isEqualToString:@"200"]) {
            
            _totalPage = [object[@"totalPage"] integerValue];
            if(refreshIndex==0){
                _personalArr = [[NSMutableArray alloc]initWithArray:[TRZPersonalModell mj_objectArrayWithKeyValuesArray:object[@"data"]]];
                if (_personalArr.count>0) {
                    _tableView.tableFooterView = [[UIView alloc]init];
                    _tableView.mj_footer.hidden = NO;
                    _tableView.backgroundColor = backColor;
                    self.bgdImage.hidden = YES;
                if(_totalPage<=1){
                    _tableView.tableFooterView = self.noLabelView;
                    _noLabelView.hidden = NO;
                    _tableView.mj_footer.hidden = YES;
                }else{
                    _tableView.mj_footer.hidden = NO;
                    _tableView.tableFooterView.hidden = YES;
                }
                
                }else{
                    _tableView.mj_footer.hidden = YES;
                    _tableView.backgroundColor = [UIColor clearColor];
                    self.bgdImage.hidden = NO;
                }
                [_tableView.mj_header endRefreshing];
            }else{
                NSArray *array = [TRZPersonalModell mj_objectArrayWithKeyValuesArray:object[@"data"]];
                if (array.count>0) {
                    [_personalArr addObjectsFromArray:array];
                }else{
                    
                    self.tableView.tableFooterView = self.noLabelView;
                    
                    _tableView.mj_footer.hidden = YES;
                }
                
            }
            [_tableView reloadData];

        }else{
            
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];

    }];
    
    
}
- (void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backColor;
    
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([[KPOUserDefaults mobile] isEqualToString:@"trzx"]) {
//        return 0;
//    }else{
        return _personalArr.count;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//注释了头文件
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//#pragma mark - 自定义分组头部
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString * identy = @"headFoot";
//    UITableViewHeaderFooterView * hf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
//    if (!hf) {
//        hf = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identy];
//        
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//        view.backgroundColor = backColor;
//        _moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, 40)];
//        _moreLabel.textColor = [UIColor grayColor];
//        if (_personalArr.count == 0) {
//            _moreLabel.text =@"";
//        }else{
//            if ([_wendaStr isEqualToString:@"1"]) {
//                if (_personalArr.count == 0) {
//                    _moreLabel.text = @"";
//                }else{
//                    _moreLabel.text = [NSString stringWithFormat:@"已回答%lu",(unsigned long)_personalArr.count];
//                }
//            }else if ([_wendaStr isEqualToString:@"0"]) {
//                if (_personalArr.count == 0) {
//                    _moreLabel.text = @"";
//                }else{
//                    _moreLabel.text = [NSString stringWithFormat:@"已提问%lu",(unsigned long)_personalArr.count];
//                }
//            }
//        }
//        _moreLabel.font = [UIFont systemFontOfSize:12];
//        _moreLabel.textAlignment = NSTextAlignmentLeft;
//        [view addSubview:_moreLabel];
////        [hf addSubview:view]; //(若将此注释：view未添加)
//    }
//    // hf.contentView.backgroundColor = [UIColor purpleColor];（去掉此行注释：可设置hf。contentView背景色），若此行和上一行都不注释，显示红色
//    return hf;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _personalArr.count-1) {
        return 130;
    }else{
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WoWenTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WoWenTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WoWenTableViewCell" owner:self options:nil] lastObject];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    TRZPersonalModell *model = [_personalArr objectAtIndex:indexPath.row];
    
    if (indexPath.row == _personalArr.count-1) {
        cell.xianLabel.hidden = YES;
    }
    [cell.icmImage sd_setImageWithURL:[NSURL URLWithString:model.headImg]placeholderImage:[UIImage imageNamed:@"展位图"]];
    cell.nameLabel.text = model.name;
    cell.wentiBtn.text = model.content;//问题
    cell.timeLabel.text = model.creatDate;//时间
    cell.gongsiLabel.text = [NSString stringWithFormat:@"%@,%@",model.userCompany,model.position];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TRZPersonalModell *model = [_personalArr objectAtIndex:indexPath.row];
    
//    QuestionDetailsViewController *questionDetailsVC = [[QuestionDetailsViewController alloc]init];
//    questionDetailsVC.questionId = model.mid;
//    questionDetailsVC.backStr = @"1";
//    [self.navigationController pushViewController:questionDetailsVC animated:YES];
    
    
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
