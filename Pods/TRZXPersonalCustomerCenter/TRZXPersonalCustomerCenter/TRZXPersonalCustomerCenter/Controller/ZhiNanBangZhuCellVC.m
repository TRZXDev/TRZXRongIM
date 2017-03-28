//
//  ZhiNanBangZhuCellVC.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/28.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "ZhiNanBangZhuCellVC.h"
#import "zhinanCell.h"
#import "GuanYuWoMenVC.h"
#import "PersonalModell.h"
#import "TRZXNetwork.h"
#import "MJExtension.h"
#import "UIColor+APP.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]

@interface ZhiNanBangZhuCellVC ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UITableView *DataTable;
@property(nonatomic,strong)NSMutableArray *dataArray1;
@property(nonatomic,strong)NSMutableArray *dataArray2;
@property(nonatomic,strong)NSMutableArray *dataArray3;
@property(nonatomic,strong)NSMutableArray *dataArray4;
@property(nonatomic,strong)NSArray *guanzhuArr;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *dataArray;//加入了用于保存数组的数组 dataArray

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSString *neirongStr;
@property (strong, nonatomic) PersonalModell *PersonalMode;

@end

@implementation ZhiNanBangZhuCellVC
//-(NSMutableArray *)dataArray1{
//    if (!_dataArray1) {
//        _dataArray1 = [NSMutableArray array];
//    }
//    return _dataArray1;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用帮助";
    self.view.backgroundColor = [UIColor trzx_BackGroundColor];
    _dataArray1 = [NSMutableArray array];
    _dataArray2 = [NSMutableArray array];
    _dataArray3 = [NSMutableArray array];
    _dataArray4 = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    NSDictionary *params = @{
                             @"requestType":@"someQuestion_Api",
                             @"apiType":@"allList"
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        if ([object[@"status_code"] isEqualToString:@"200"]) {
            
            _guanzhuArr = [PersonalModell mj_objectArrayWithKeyValuesArray:object[@"data"]];
            for (PersonalModell *mode in _guanzhuArr) {
                if ([mode.questionType isEqualToString:@"1"]) {
                    [_dataArray1 addObject:mode.questionName];
                }else if ([mode.questionType isEqualToString:@"2"]) {
                    [_dataArray2 addObject:mode.questionName];
                }else if ([mode.questionType isEqualToString:@"3"]) {
                    [_dataArray3 addObject:mode.questionName];
                }else {
                    [_dataArray4 addObject:mode.questionName];
                }
            }

            _titleArray = [[NSMutableArray alloc] initWithObjects:@"投融学院", @"投融社交",@"投融市场",  nil];
            _dataArray = [[NSMutableArray alloc] initWithObjects:_dataArray1, _dataArray2,_dataArray3, nil]; //初始化dataArray,元素为数组
            
            [self jiazaiView];
        }
        
    }];
}

- (void)jiazaiView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor trzx_BackGroundColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

//制定个性标题，这里通过UIview来设计标题，功能上丰富，变化多。

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
//    [view setBackgroundColor:[UIColor brownColor]];//改变标题的颜色，也可用图片
    view.backgroundColor = [UIColor trzx_BackGroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 40)];
    
    label.textColor = heizideColor;
    
    label.text = [_titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

//指定标题的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

//指定有多少个分区(Section)，默认为1

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_titleArray count];
    
}



//指定每个分区中有多少行，默认为1

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /* switch (section) {
     
     case 0:
     
     return  [dataArray1 count];
     
     break;
     
     case 1:
     
     return  [dataArray2 count];
     
     break;
     
     default:
     
     return 0;
     
     break;
     
     }*/
    
    /*  for(int i = 0; i < [titleArray count]; i++){
     
     if(section == i){
     
     return [[dataArray objectAtIndex:section] count];
     
     }
     
     }*/
    
    //上面的方法也是可行的，大家参考比较下
    
    return [[_dataArray objectAtIndex:section] count];  //取dataArray中的元素，并根据每个元素（数组）来判断分区中的行数。
   
}



//绘制Cell

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    zhinanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhinanCell"];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"zhinanCell" owner:self options:nil]lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = backColor;
//    cell.yzImage.hidden = YES;
    cell.titleLabel.textColor = zideColor;
    cell.lineLabel.backgroundColor = [UIColor trzx_BackGroundColor];
    /*switch (indexPath.section) {
     
     case 0:
     
     [[cell textLabel]
     
     setText:[dataArray1 objectAtIndex:indexPath.row]];
     
     break;
     
     case 1:
     
     [[cell textLabel]
     
     setText:[dataArray2 objectAtIndex:indexPath.row]];
     
     break;
     
     default:
     
     [[cell textLabel]
     
     setText:@"Unknown"];
     
     }*/
    
    //上面的方法也可行，大家比较下。
    
    [cell.titleLabel setText:[[_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    
    //同上，取出dataArray中每个分区所对应的元素（数组），并通过其来取值。 （大家要有想像力， 复制代码试试就明白了）

    return cell;  
    
    
    
}  

//改变行的高度  

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{  
    
    return 45;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //行被选中后，自动变回反选状态的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UILabel * labe = [[UILabel alloc]init];
    [labe setText:[[_dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    GuanYuWoMenVC * bangzhu = [[GuanYuWoMenVC alloc] init];
    bangzhu.titleStr = labe.text;
    for (PersonalModell *mode in _guanzhuArr) {
        if ([mode.questionName isEqualToString:labe.text]) {
            
            bangzhu.neirongStr = mode.questinCotent;
        }
    }
    [self.navigationController pushViewController:bangzhu animated:YES];

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
