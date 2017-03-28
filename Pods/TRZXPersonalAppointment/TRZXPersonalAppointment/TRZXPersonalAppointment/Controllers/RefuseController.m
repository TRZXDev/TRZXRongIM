//
//  CancelViewController.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/8.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "RefuseController.h"

#import "TRZXPersonalAppointmentPch.h"

#import "IQKeyboardManager.h"

@interface RefuseController () <UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic)UITableViewCell *oldCell;

@property (strong, nonatomic)UILabel *textViewLable;
@property (strong, nonatomic)UILabel *numberLable;

@property (copy, nonatomic) NSString *qxCell;
@property (copy, nonatomic) NSString *textCell;
@property (strong, nonatomic) UITextView *textView;

@property (copy, nonatomic) NSString *qxReason;
@property (strong, nonatomic) NSString *panduanStr;

@end

@implementation RefuseController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拒绝约见";
    self.view.backgroundColor = backColor;
    dataArr = @[@"我最近很忙,不便见面",@"您的问题解决不了.",@"您的个人介绍不够清楚,我不知道能否帮到您.",@"您的问题不够清晰,我不知道能否帮到您.",@"其他原因:请填写详情"];
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, WIDTH(self.view), 250)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = backColor;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //    [myTableView addGestureRecognizer:tap];
    [self.view addSubview:myTableView];
    [self qitaView];
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(0, HEIGTH(self.view)-50, WIDTH(self.view), 50);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = TRZXMainColor;
    [self.view addSubview:submitBtn];
}

- (void)submitClick:(UIButton *)sender
{
    if ([_panduanStr isEqual:@"1"]) {
        if (_qxReason.length>0){
            NSDictionary *params = @{
                                     @"requestType":@"OtoSchoolMeet_Api",
                                     @"apiType":@"disableMeet",
                                     @"qxReason":_qxReason?_qxReason:@"",
                                     @"meetStatus":[NSString stringWithFormat:@"%ld",(long)self.meetStase+1],
                                     @"id":self.mid?self.mid:@""
                                     };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {
                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationMeet object:nil];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        } else {
//            [LCProgressHUD showInfoMsg:@"请选择或输入取消原因"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择或输入取消原因" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else
    {
        if (_textView.text.length>0){
            NSDictionary *params = @{
                                     @"requestType":@"OtoSchoolMeet_Api",
                                     @"apiType":@"disableMeet",
                                     @"qxReason":_qxReason?_qxReason:@"",
                                     @"meetStatus":[NSString stringWithFormat:@"%ld",(long)self.meetStase+1],
                                     @"id":self.mid?self.mid:@""
                                     };
            [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id responseObj, NSError *error) {

                if ([responseObj[@"status_code"] isEqualToString:@"200"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationMeet object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        } else {
//            [LCProgressHUD showInfoMsg:@"请输入取消原因"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入取消原因" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row < dataArr.count) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = dataArr[indexPath.row];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < dataArr.count-1) {
        _panduanStr = @"1";
        _qxReason = dataArr[indexPath.row];
        _textView.hidden = YES;
    }else if (indexPath.row == 4)
    {
        _panduanStr = @"0";
        _textView.hidden = NO;
//        _qxReason = _textView.text;
    }

    _oldCell.contentView.backgroundColor = [UIColor whiteColor];
    _oldCell.textLabel.textColor = [UIColor blackColor];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = moneyColor;
    cell.textLabel.textColor = [UIColor whiteColor];
//    _qxCell = cell.textLabel.text;
    _oldCell = cell;
    
}
- (void)qitaView
{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 324, WIDTH(self.view), 100)];
    _textView.delegate = self;
    _textViewLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 140, 20)];
    _textViewLable.text = @"请简单描述取消原因";
    _textViewLable.font = [UIFont systemFontOfSize:13];
    _textViewLable.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_textViewLable];
    if ([_textView.text length] == 0) {
        [_textViewLable setHidden:NO];
    }else{
        [_textViewLable setHidden:YES];
    }
    if (_textView.text.length <=100) {
        _numberLable.text = [NSString stringWithFormat:@"%lu字",100-_textView.text.length];
    } else {
        NSString *subText = [_textView.text substringToIndex:100];
        _textView.text = subText;
    }
    _numberLable = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(self.view)-60, 80, 50, 20)];
//    _numberLable.text = @"100字";
    _numberLable.textAlignment = NSTextAlignmentRight;
    _numberLable.font = [UIFont systemFontOfSize:13];
    _numberLable.textColor = [UIColor lightGrayColor];
    [_textView addSubview:_numberLable];
    
    [self.view addSubview:_textView];
    _textView.hidden = YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    if (![text isEqualToString:@""])
        
    {
        
        _textViewLable.hidden = YES;
        //        _numberLable.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        _textViewLable.hidden = NO;
        //        _numberLable.hidden = NO;
        
    }
    
    if (range.location >= 100) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [_textViewLable setHidden:NO];
    }else{
        [_textViewLable setHidden:YES];
    }
    if (textView.text.length <=100) {
        _numberLable.text = [NSString stringWithFormat:@"%lu字",100-textView.text.length];
    } else {
        NSString *subText = [textView.text substringToIndex:100];
        textView.text = subText;
    }
    if (textView.text.length >=100) {
        _numberLable.text = @"0字";
    }
    _qxReason = _textView.text;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
