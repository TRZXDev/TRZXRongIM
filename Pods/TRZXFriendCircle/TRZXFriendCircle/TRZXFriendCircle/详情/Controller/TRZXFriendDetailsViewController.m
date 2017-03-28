//
//  TRZXFriendDetailsViewController.m
//  TRZX
//
//  Created by 张江威 on 2016/11/9.
//  Copyright © 2016年 Tiancaila. All rights reserved.
//

#import "TRZXFriendDetailsViewController.h"
#import "TRZXFriendDetailsCell.h"
#import "TRZXFriendLineCellModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "TRZXPhotoTextModel.h"
#import "ShareDeleViewController.h"
#import "IQKeyboardManager.h"
#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]



#define kTimeLineTableViewCellId @"TRZXFriendDetailsCell"

static CGFloat textFieldH = 40;


@interface TRZXFriendDetailsViewController ()<TRZXFriendDetailsCellDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>



@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUserID;
@property (nonatomic, copy) NSString *commentToUserName;

@property (nonatomic, copy) NSString *commentHeadImage;

@property (nonatomic, copy) NSString * commentIdStr;//删除评论的ID
@property (nonatomic, copy) NSString * hfcommentStr;//回复评论的
@property (nonatomic, copy) NSString * commentStr;//评论的内容


@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic)NSInteger photoMaxCount;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@property (nonatomic,strong) NSMutableArray * photoTimeArray;
@property (nonatomic,strong) NSMutableArray * photoArray;




@end

@implementation TRZXFriendDetailsViewController

{
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSThread *thread;
    UIImage *icImage;
    NSData *_data;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    NSInteger imagePickerTag;
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [IQKeyboardManager sharedManager].enable = NO;

    if ([_navStr isEqualToString:@"1"]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:heizideColor}];
    }else{
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:55/255.0 green:54/255.0 blue:59/255.0 alpha:0.85]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    _textField.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{

    [_textField resignFirstResponder];

    [IQKeyboardManager sharedManager].enable = YES;

    
    if (![_navStr isEqualToString:@"1"]) {
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController.navigationBar setBarTintColor:nil];
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.tintColor = nil;
    [_textField resignFirstResponder];
    _textField.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDynamicNotification" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
//    if ([_navStr isEqualToString:@"1"]) {
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem kipo_LeftTarButtonItemDefaultTarget:self titelabe:@"返回" color:zideColor action:@selector(leftBarButtonItemPressed:)];
//    }else{
//        
//        self.navigationItem.leftBarButtonItem = [UIBarButtonItem kipo_LeftTarButtonItemDefaultTarget:self titelabe:@"返回白" color:[UIColor whiteColor] action:@selector(leftBarButtonItemPressed:)];
//    }
    self.commentHeadImage = _selfIconStr;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    _pageNo = 1;
    [self createData:_pageNo refresh:0];
    
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView registerClass:[TRZXFriendDetailsCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    UIView * vieww = [[UIView alloc]init];
    vieww.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    vieww.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = vieww;
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField resignFirstResponder];
    
}

- (void)dealloc
{
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.layer.borderWidth = 1;
    _textField.placeholder = @" 评论";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}
//判断是否全是空格
- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
- (void)textChanged:(UITextField *)textfield
{
    if (textfield.text.length <=1500) {
        
    } else {
        NSString *subText = [textfield.text substringToIndex:1500];
        textfield.text = subText;
    }
    
}
- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    
    NSDictionary *params = @{@"requestType":@"Circle_Api",
                             @"apiType":@"info",
                             @"mid":_userIdStr?_userIdStr:@""};
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
        
        if ([object[@"status_code"] isEqualToString:@"200"]) {

            TRZXFriendLineCellModel *model = [TRZXFriendLineCellModel new];
            
            TRZXPhotoTextModel * modell = [TRZXPhotoTextModel mj_objectWithKeyValues:object[@"data"]];;
            
            model.type = modell.type;//类型
            model.objId = modell.objId;//课程的id
            model.url = modell.url;//商业企划书
            model.deleted = modell.deleted;//分享是否删除
            model.shareTitle = modell.shareTitle;//分享的标题
            model.shareImg = modell.shareImg;//分享的图片
            model.iconName = modell.headImg;//头像
            model.name = modell.userName;//姓名
            model.picNamesArray = [NSMutableArray arrayWithArray:modell.pics];//图片的数组
            if ([modell.isGood isEqualToString:@"1"]) {
                model.liked = YES;
            }else{
                model.liked = NO;
            }
            // 评论数据
            NSArray * CommentArr =  [TRZXFriendCommentModel mj_objectArrayWithKeyValuesArray:modell.comments];
            
            NSMutableArray *tempComments = [NSMutableArray new];
            for (int i = 0; i < CommentArr.count; i++) {
                TRZXFriendLineCellCommentItemModel *commentModel = [TRZXFriendLineCellCommentItemModel new];
                TRZXFriendCommentModel * modelle = CommentArr[i];
                commentModel.beCommentId = modelle.beCommentId;//心情的id
                commentModel.parentId = modelle.parentId;//上条评论的id
                commentModel.firstUserName = modelle.userName;//谁
                commentModel.firstUserId = modelle.userId;//谁的ID
                commentModel.secondUserName = modelle.parentUserName;//回复谁
                commentModel.secondUserId = modelle.parentUser;//回复谁的ID
                commentModel.commentString = modelle.count;//回复的内容
                commentModel.mid = modelle.mid;//评论的id
                commentModel.headImage = modelle.headImage;//头像
                commentModel.date = modelle.data;
                [tempComments addObject:commentModel];
            }
            model.commentItemsArray = [tempComments copy];//评论的数组
            
            // 点赞数据
            NSArray * likeArr =  [TRZXFriendLikeModel mj_objectArrayWithKeyValuesArray:modell.goods];
            
            NSMutableArray *tempLikes = [NSMutableArray new];
            for (int i = 0; i < likeArr.count; i++) {
                TRZXFriendLineCellLikeItemModel *likeModel = [TRZXFriendLineCellLikeItemModel new];
                TRZXFriendLikeModel * modele = likeArr[i];
                likeModel.userName = modele.userName;
                likeModel.userId = modele.userId;
                likeModel.headImage = modele.headImage;
                [tempLikes addObject:likeModel];
            }
            model.likeItemsArray = [tempLikes copy];//点赞的数组
            model.msgContent = modell.describe;
            model.date = modell.data;//时间
            model.mid = modell.mid;//对方的id
            model.userId = modell.userId;//自己的id
            
            [self.dataArray addObject:model];
        
         [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else if ([object[@"status_code"] isEqualToString:@"205"]){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:object[@"status_dec"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
            [self.delegate refresh];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXFriendDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];

    cell.contentLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longLabelPress:)];
    longPressGR.minimumPressDuration = 1;
    [cell.contentLabel addGestureRecognizer:longPressGR];
    
    cell.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick:)];
    [cell addGestureRecognizer:singleTap10];
    
    cell.indexPath = indexPath;
    cell.iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPersonalClick:)];
    [cell.iconView addGestureRecognizer:singleTap1];

    cell.shareCellView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick:)];
    [cell.shareCellView addGestureRecognizer:singleTap0];
    
    __weak typeof(self) weakSelf = self;
    if (!cell.more2ButtonClickedBlock) {
        [cell setMore2ButtonClickedBlock:^(NSIndexPath *indexPath) {
            TRZXFriendLineCellModel *model = weakSelf.dataArray[indexPath.row];
            model.issOpening = !model.issOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        //头像的跳转
        [cell setDidClickCommentIconImageBlock:^(NSString * mid){
//            PersonalInformationVC * studentPersonal=[[PersonalInformationVC alloc]init];
//            studentPersonal.otherStr = @"1";
//            studentPersonal.headBackStr = @"1";
//            studentPersonal.midStrr = mid;
//            [self.navigationController pushViewController:studentPersonal animated:true];
        }];
        
        [cell setDidClick1CopyBlock:^(NSString *comment, CGRect rectInWindow){
            [_textField resignFirstResponder];
            [self becomeFirstResponder];
            _copStr = comment;
            TRZXFriendDetailsCell *cell = (TRZXFriendDetailsCell *)self.view;
            [cell becomeFirstResponder];
            UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyItemClicked:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
            [menu setTargetRect:rectInWindow inView:cell.superview];
            [menu setMenuVisible:YES animated:YES];
        }];
        //取消还是回复
        [cell setDidClick2CommentLabelBlock:^(NSString *commentId,NSString *commentName,NSString *parentId,NSString *headImage,NSString *mid,NSString *comment, CGRect rectInWindow, NSIndexPath *indexPath) {
            if ([commentId isEqualToString:_selfIDStr]) {
                weakSelf.currentEditingIndexthPath = indexPath;
//                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
                _commentIdStr = mid;
                _hfcommentStr = parentId;
                _commentStr = comment;
//                sheet.tag = 20161101+indexPath.row;
//                [sheet showInView:self.view];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    TRZXFriendLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.commentItemsArray];
                    NSDictionary *params = @{@"requestType":@"Circle_Api",
                                             @"apiType":@"deletComment",
                                             @"mid":_commentIdStr};
                    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
                        
                        if (data) {
                            //删除评论事件
                            TRZXFriendLineCellCommentItemModel *tempCommentModel = nil;
                            for (TRZXFriendLineCellCommentItemModel *CommentModel in model.commentItemsArray) {
                                if ([CommentModel.firstUserId isEqualToString:_selfIDStr]&&[CommentModel.commentString isEqualToString:_commentStr]) {//默认自己的id
                                    tempCommentModel = CommentModel;
                                    break;
                                }
                            }
                            [temp removeObject:tempCommentModel];
                            model.commentItemsArray = [temp copy];
                            [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
                            
                        }
                        
                        
                    }];
                }];
                
            }else{
                weakSelf.textField.placeholder = [NSString stringWithFormat:@"  回复：%@", commentName];
                weakSelf.currentEditingIndexthPath = indexPath;
                [weakSelf.textField becomeFirstResponder];
                weakSelf.isReplayingComment = YES;
                weakSelf.commentIdStr = mid;
                weakSelf.hfcommentStr = parentId;
                weakSelf.commentStr = comment;
//                weakSelf.commentHeadImage = headImage;
                weakSelf.commentToUserName = commentName;
                weakSelf.commentToUserID = commentId;
                [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
            }
            
        }];
        [cell setDelete2ButtonClickedBlock:^(NSIndexPath *indexPath) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                TRZXFriendLineCellModel *model = weakSelf.dataArray[indexPath.row];
                NSDictionary *params = @{@"requestType":@"Circle_Api",
                                         @"apiType":@"deletCir",
                                         @"mid":model.mid};
                [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                    
                }];
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
        
        [cell  setTrzxPresent2Block:^(NSString *commentId) {
            [_textField resignFirstResponder];
//            PersonalInformationVC * studentPersonal=[[PersonalInformationVC alloc]init];
//            studentPersonal.otherStr = @"1";
//            studentPersonal.headBackStr = @"1";
//            studentPersonal.midStrr = [KPOUserDefaults userId];
//            [self.navigationController pushViewController:studentPersonal animated:true];
        }];
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
//    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyItemClicked:)) {
        return YES;
    }
    return NO;
}

-(void)copyItemClicked:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = _copStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TRZXFriendDetailsCell class] contentViewWidth:[self cellContentViewWith]];
}


-(void)longLabelPress:(UILongPressGestureRecognizer *) longPress{
    [_textField resignFirstResponder];
    if (longPress.state == UIGestureRecognizerStateEnded) {
        //        NSLog(@"111");
        return;
    }else if (longPress.state == UIGestureRecognizerStateBegan){
        //        NSLog(@"222");
        [self becomeFirstResponder];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [longPress.view.superview convertRect:longPress.view.frame toView:window];
        TRZXFriendLineCellModel *model = self.dataArray[longPress.view.tag-20161129];
        _copStr = model.msgContent;
        
        TRZXFriendDetailsCell *cell = (TRZXFriendDetailsCell *)self.view;
        [cell becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyItemClicked:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:rect inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];
        
        
        return ;
    }
    
}


//
- (void)tableViewClick:(UITapGestureRecognizer *)tap
{
    [_textField resignFirstResponder];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - TRZXFriendDetailsCellDelegate

- (void)didClick2cCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    __weak typeof(self) weakSelf = self;
    weakSelf.textField.placeholder = @"";
    [weakSelf.textField becomeFirstResponder];
    weakSelf.isReplayingComment = NO;
    weakSelf.commentToUserName = _selfNameStr;//默认自己的名字
    weakSelf.commentToUserID = _selfIDStr;//默认自己的ID
//    weakSelf.commentHeadImage = [KPOUserDefaults head_img];
    [self adjustTableViewToFitKeyboard];
    
}

//点赞事件
- (void)didClick2LikeButtonInCell:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    TRZXFriendLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
    
    //添加网络请求然后在里面做判断
    //    NSString * likeSttr;
    if (!model.isLiked) {
        NSDictionary *params = @{@"requestType":@"Circle_Api",
                                 @"apiType":@"good",
                                 @"mid":model.mid};
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
            if ([object[@"status_code"] isEqualToString:@"200"]) {
                //点赞的事件
                TRZXFriendLineCellLikeItemModel *likeModel = [TRZXFriendLineCellLikeItemModel new];
                likeModel.userName = _selfNameStr;//默认自己的名字
                likeModel.userId = _selfIDStr;//默认自己的ID
                likeModel.headImage =  _selfIconStr;//默认自己的头像
                [temp addObject:likeModel];
                model.liked = YES;
                model.likeItemsArray = [temp copy];
                
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }];
        
        
    } else {
        NSDictionary *params = @{@"requestType":@"Circle_Api",
                                 @"apiType":@"delGood",
                                 @"mid":model.mid};
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {            if ([object[@"status_code"] isEqualToString:@"200"]) {
                //取消点赞的事件
                TRZXFriendLineCellLikeItemModel *tempLikeModel = nil;
                for (TRZXFriendLineCellLikeItemModel *likeModel in model.likeItemsArray) {
                    if ([likeModel.userId isEqualToString:_selfIDStr]) {//默认自己的ID
                        tempLikeModel = likeModel;
                        break;
                    }
                }
                [temp removeObject:tempLikeModel];
                model.liked = NO;
                model.likeItemsArray = [temp copy];
                
                [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        }];
    }
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内容不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (textField.text.length) {
        [_textField resignFirstResponder];
        
        TRZXFriendLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObjectsFromArray:model.commentItemsArray];
        TRZXFriendLineCellCommentItemModel *commentItemModel = [TRZXFriendLineCellCommentItemModel new];
        NSString * userId;
        NSString * userName;
        NSString * otherId;
        NSString * otherName;
        NSString * typeStr;
        NSString * parenStr;
        NSString * midStr;
//        NSString * headImageStr;
        
        if (self.isReplayingComment) {
            //回复
            userName = _selfNameStr;//默认自己的名字
            userId = _selfIDStr;//默认自己的ID
            otherName = self.commentToUserName;
            otherId = self.commentToUserID;
            parenStr = self.commentIdStr;
            midStr = self.commentIdStr;
//            headImageStr = self.commentHeadImage;
//            headImageStr = [KPOUserDefaults head_img];
            typeStr = @"reply";
        } else {
            //评论
            userName = _selfNameStr;//默认自己的名字
            userId = _selfIDStr;//默认自己的ID
            otherName = @"";
            otherId = @"";
            typeStr = @"comment";
            parenStr = @"";
//            headImageStr = self.commentHeadImage;
            midStr = self.commentIdStr;
        }

        NSDictionary *params = @{@"requestType":@"Circle_Api",
                                 @"apiType":@"good",
                                 @"type":typeStr?typeStr:@"",//评论还是回复
                                 @"mid":model.mid?model.mid:@"",//评论的对应的那条说说的id
                                 @"parentId":parenStr?parenStr:@"",//若为回复别人的评论(及type为reply时)传 要回复的那条评论的id
                                 @"parentUser":otherId?otherId:@"",//若为回复别人的评论(及type为reply时)传 要回复的那条评论的人的userId
                                 @"count":textField.text?textField.text:@""//评论内容
                                 };
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {

            if (data) {
                TRZXFriendCommentModel * mod = [TRZXFriendCommentModel mj_objectWithKeyValues:data[@"data"]];
//                NSDate *currentDate = [NSDate date];//获取当前时间，日期
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
//                NSString *dateString = [dateFormatter stringFromDate:currentDate];
                if (self.isReplayingComment) {
                    commentItemModel.firstUserName = _selfNameStr;//默认自己的名字
                    commentItemModel.firstUserId = _selfIDStr;//默认自己的id
                    commentItemModel.secondUserName = self.commentToUserName;
                    commentItemModel.secondUserId = self.commentToUserID;
                    commentItemModel.parentId = self.hfcommentStr;
                    commentItemModel.mid = self.commentIdStr;
                    commentItemModel.commentString = textField.text;
                    commentItemModel.headImage = self.commentHeadImage;
                    self.isReplayingComment = NO;
                } else {
                    commentItemModel.firstUserName = _selfNameStr;//默认自己的mingzi
                    commentItemModel.commentString = textField.text;
                    commentItemModel.firstUserId = _selfIDStr;//默认自己的id
                    commentItemModel.mid = mod.mid;
                    commentItemModel.headImage = self.commentHeadImage;
                }
                commentItemModel.date = mod.data;
                [temp addObject:commentItemModel];
                model.commentItemsArray = [temp copy];
//                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
                _textField.placeholder = @" 评论";
                _textField.text = @"";



            }



        }];

        return YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"内容不能为空" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    return NO;
}



- (void)keyboardNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y - textFieldH, rect.size.width, textFieldH);
    if (rect.origin.y == [UIScreen mainScreen].bounds.size.height) {
        textFieldRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
        //        textFieldRect = rect;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _textField.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + textFieldH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}


//左侧按钮的返回
-(void)leftBarButtonItemPressed:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//分享的跳转
- (void)shareClick:(UITapGestureRecognizer *)tap{
    NSInteger indext = tap.view.tag-20161111;
    TRZXFriendLineCellModel *model = self.dataArray[indext];
    NSLog(@"点击的ID----%@---跳转到对应的页面",model.objId);
    
    
}
//头像跳转
- (void)headPersonalClick:(UITapGestureRecognizer *)tap
{
//    PersonalInformationVC * studentPersonal=[[PersonalInformationVC alloc]init];
//    studentPersonal.otherStr = @"1";
//    studentPersonal.headBackStr = @"1";
//    if (tap.view.tag == 20161025) {
//        studentPersonal.midStrr = [KPOUserDefaults userId];
//    }else{
//        NSInteger indext = tap.view.tag-20161029;
//        TRZXFriendLineCellModel *model = self.dataArray[indext];
//        studentPersonal.midStrr = model.userId;
//    }
//    [self.navigationController pushViewController:studentPersonal animated:true];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
