//
//  GuanYuWoMenVC.m
//  tourongzhuanjia
//
//  Created by 移动微世界 on 16/4/27.
//  Copyright © 2016年 JWZhang. All rights reserved.
//

#import "GuanYuWoMenVC.h"
#import "GuanYuWoMenCell.h"
#import "BangZhuTableViewCell.h"


/** 主题颜色 */
#define TRZXMainColor [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1]
#define backColor [UIColor colorWithRed:240.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]


@interface GuanYuWoMenVC ()<UITableViewDelegate,UITableViewDataSource>
{
    CGSize size;
}
@property (strong, nonatomic)UITableView *tableView;


@end

@implementation GuanYuWoMenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    if ([_panduanStr isEqualToString:@"guanyu"]) {
        self.title = @"关于我们";
    }else{
        self.title = @"使用帮助";
    }
    if ([_panduanStr isEqualToString:@"guanyu"]) {
        _neirongStr = @"        投融在线是我国首个股权融资全过程服务平台,涵盖投融市场、投融学院、投融社交三大版块；聚集股东、专家、投资人、交易中心、政府园区五个角色。\n\n        投融在线面向全国4000万企业股东开放，以“助力企业发展，促进民族经济”为己任，致力于把一线城市的专家资源下沉到二、三线城市的中小企业，把一线城市的投资机构下沉到二、三线城市的中小实体经济中，利于用大数据技术解决传统投融资领域信息不对称痛点，通过整合融资方、投资机构、中介服务机构及股权交易中心等多方面资源，缩短融资链条，帮助广大中小企业实现快速融资。";
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = backColor;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.scrollEnabled = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_panduanStr isEqualToString:@"guanyu"]) {
        return 240 + size.height;
    }else{
        return 80 + size.height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_panduanStr isEqualToString:@"guanyu"]) {
        GuanYuWoMenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuanYuWoMenCell"];
        if (!cell) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"GuanYuWoMenCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.icmImage.image = [UIImage imageNamed:@"shangbiao"];
        cell.titleLabel.text = @"投融在线";
        cell.neirongLabel.text = _neirongStr;
        cell.backgroundColor = backColor;
        size = [cell.neirongLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-16, MAXFLOAT)];
        return cell;
    }else{
        BangZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BangZhuTableViewCell"];
        if (!cell) {
            cell =[[[NSBundle mainBundle] loadNibNamed:@"BangZhuTableViewCell" owner:self options:nil]lastObject];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = _titleStr;
        cell.neirongLabel.text = _neirongStr;
        cell.backgroundColor = backColor;
        size = [cell.neirongLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-16, MAXFLOAT)];
        return cell;
    }
    
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
