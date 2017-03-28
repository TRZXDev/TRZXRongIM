//
//  TRZXFriendLineTableViewController.m


#import "TRZXFriendLineTableViewController.h"
#import "TRZXFriendGraphicController.h"
#import "TRZXFriendLineTableHeaderView.h"
#import "TRZXFriendLineRefreshHeader.h"
#import "TRZXFriendLineCell.h"
#import "DynamicHomeViewController.h"
#import "TRZXFriendLineCellModel.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "TRZXPhotoTextModel.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "TRZXFriendMessageView.h"
#import "SendTimeLineViewController.h"
#import "ShareDeleViewController.h"
#import "IQKeyboardManager.h"
#import "UIViewController+APP.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "TRZXNetwork.h"
#import "SDImageCache.h"
#import "SDWebImageCompat.h"
#import "UIImageView+WebCache.h"

#define zideColor [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1]
#define heizideColor [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1]
#define kTimeLineTableViewCellId @"TRZXFriendLineCell"

static CGFloat textFieldH = 40;

@interface TRZXFriendLineTableViewController () <TRZXFriendLineCellDelegate, UITextFieldDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,NewDynamicDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isReplayingComment;
@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, copy) NSString *commentToUserID;
@property (nonatomic, copy) NSString *commentToUserName;
@property (nonatomic, copy) NSString * commentIdStr;//删除评论的ID
@property (nonatomic, copy) NSString * hfcommentStr;//回复评论的
@property (nonatomic, copy) NSString * commentStr;//评论的内容

@property (nonatomic, copy) NSString * coverStr;//封面图
@property (nonatomic, copy) NSString * headStr;//头像
@property (nonatomic, copy) NSString * nameStr;//名字

@property (nonatomic, copy) NSString * refrStr;//刷新回顶部的

@property (nonatomic, copy) NSString * actionStr;//弹出判断


@property (nonatomic,strong) UIImagePickerController * pickerCamera;
@property (nonatomic,strong) UIImagePickerController * PickerImage;
@property (nonatomic,strong) TRZXFriendLineTableHeaderView *headerView;//顶部背景图

@property (nonatomic,strong) TRZXFriendMessageView *messageView;//新消息

@property (nonatomic, strong) UIButton *rightBtn;

//@property (nonatomic, strong) TRZXFriendLineCellModel * topModel;//暂存顶部的model

@property (nonatomic) NSInteger pageNo;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic)NSInteger photoMaxCount;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@property (nonatomic,strong) NSMutableArray * photoTimeArray;
@property (nonatomic,strong) NSMutableArray * photoArray;

//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TRZXFriendLineTableViewController

{
    TRZXFriendLineRefreshHeader *_refreshHeader;
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
    NSThread *thread;
    UIImage *icImage;
    NSData *_data;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    NSInteger imagePickerTag;
    NSDictionary* datee;
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
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enable = NO;
    
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:heizideColor}];
    _textField.hidden = NO;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refersh) name:@"NewDynamicNotification" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{

    [IQKeyboardManager sharedManager].enable = YES;

//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.tintColor = nil;
    [_textField resignFirstResponder];
    _textField.hidden = YES;
    [_refreshHeader removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];

//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:self.tableView];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    self.title = @"投融圈";
    
    _selfIconStr = @"首页头像";
    _selfNameStr = @"张江威";
    _selfIDStr = @"d6709590d4154b8a945415cf91757c8f";
    
//    [self setRightBarItemWithString:@"发送"];
    
    
    self.tableView.separatorStyle = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _rightBtn.frame = CGRectMake(0, 0, 50, 35);
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"]];
    rightImg.frame = CGRectMake(15, -5, 45, 45);
    [_rightBtn addSubview:rightImg];
    [_rightBtn addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPressGR.minimumPressDuration = 1;
    [_rightBtn addGestureRecognizer:longPressGR];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
//    [LCProgressHUD showLoading:@"正在加载"];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    _pageNo = 1;
    [self createData:_pageNo refresh:0];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo+=1;
        if(_pageNo <=_totalPage){
            self.tableView.mj_footer.hidden = YES;
            [self createData:self.pageNo refresh:1];
            
//            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            UIView * viw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
            
            self.tableView.tableFooterView = viw;
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer.hidden = YES;
    
    _headerView = [TRZXFriendLineTableHeaderView new];
    _headerView.frame = CGRectMake(0, 0, 0, self.view.frame.size.width-90);
    _headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _headerView;
    _headerView.backgroundImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fengmianClick:)];
    [_headerView.backgroundImageView addGestureRecognizer:singleTap];
    _headerView.iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPersonalClick:)];
    [_headerView.iconView addGestureRecognizer:singleTap1];
    
//    [self reloadTop];
    
    [self.tableView registerClass:[TRZXFriendLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    
    [self setupTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refersh) name:RCDCommentCircleNotification object:nil];
}

//推送
-(void)refersh{
    _pageNo = 1;
    [self createData:self.pageNo refresh:0];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_textField resignFirstResponder];
    
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [TRZXFriendLineRefreshHeader refreshHeaderWithTheCenter:CGPointMake(40, 45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                weakSelf.tableView.mj_footer.hidden = NO;
                _pageNo = 1;
                [weakSelf createData:weakSelf.pageNo refresh:0];
                [weakHeader endRefreshing];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            });
        }];
        [weakSelf.tableView.superview addSubview:_refreshHeader];
    }
}

- (void)dealloc
{
    [_refreshHeader removeFromSuperview];
    
    [_textField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTextField
{
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8].CGColor;
    _textField.layer.borderWidth = 1;
    [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, textFieldH);
    [[UIApplication sharedApplication].keyWindow addSubview:_textField];
    
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

- (void)createData:(NSInteger)pageNo refresh:(NSInteger)refreshIndex{
    NSDictionary *params = @{
                             @"requestType":@"Circle_Api",
                             @"apiType":@"list",
                             @"pageNo":[NSString stringWithFormat:@"%ld",(long)_pageNo]
                             };
    [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id data, NSError *error) {
        
        if (data) {

            datee = data[@"data"];
            _totalPage = [data[@"totalPage"] integerValue];
//            NSMutableArray * dateArr =  [NSMutableArray arrayWithArray:[TRZXPhotoTextModel mj_objectArrayWithKeyValuesArray:datee]];
            NSMutableArray * dateArr = [NSMutableArray array];
            if(refreshIndex==0){
                _coverStr = data[@"topPic"];//封面
                [self.dataArray removeAllObjects];
                dateArr =  [NSMutableArray arrayWithArray:[TRZXPhotoTextModel mj_objectArrayWithKeyValuesArray:datee]];

                if (dateArr.count>0) {
                    self.tableView.tableFooterView.hidden = YES;
                    self.tableView.mj_footer.hidden = NO;
                }else{

                    UILabel * noLabelView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
                    noLabelView.text = @"— 暂无内容 —";
                    noLabelView.textAlignment = NSTextAlignmentCenter;
                    noLabelView.textColor = zideColor;
                    self.tableView.tableFooterView = noLabelView;
                    self.tableView.mj_footer.hidden = YES;
                }
            }else{
                NSMutableArray *array = [TRZXPhotoTextModel mj_objectArrayWithKeyValuesArray:datee];

                if (array.count>0) {
                    self.tableView.mj_footer.hidden = NO;
                    [dateArr addObjectsFromArray:array];
                    [self.tableView.mj_footer endRefreshing];
                }else{
                    self.tableView.mj_footer.hidden = YES;
                }
            }

            TRZXFriendLineCellModel *models = [TRZXFriendLineCellModel new];
            //是否有新消息
            if ([data[@"count"] integerValue] <= 0 ) {
                _messagStr = @"1";
            }else{
                _messagStr = @"0";
            }
            
            models.iconName = _selfIconStr;//头像(默认的空头像)
            models.name = _selfNameStr;//姓名(默认的空名字)
            models.coverImage = _coverStr;//封面头像
            _messagImgStr = data[@"msgImage"];//新消息头像(需要后期推送)
            _messagTitStr = [NSString stringWithFormat:@"%@条新消息",data[@"count"]];//新消息条数(需要后期推送)
            _headerView.model = models;

            for (int i = 0; i < dateArr.count; i++) {
                TRZXFriendLineCellModel *model = [TRZXFriendLineCellModel new];
                TRZXPhotoTextModel * modell = dateArr[i];

                model.type = modell.type;//类型
                model.objId = modell.objId;//课程的id
                model.url = modell.url;//商业企划书
                model.shareTitle = modell.shareTitle;//分享的标题
                model.deleted = modell.deleted;//分享是否删除
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
            }
            [self.tableView reloadData];
            if(refreshIndex==0&&[_refrStr isEqualToString:@"0"]){
//                [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                _refrStr = @"1";
            }
            [self.tableView.mj_footer endRefreshing];
        }

    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.

//    [[SDWebImageManager sharedManager] cancelAll];
//    [[SDImageCache sharedImageCache] clearDisk];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    TRZXFriendLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId];
    if (!cell) {
        cell = [[[NSBundle bundleForClass:[self class]]loadNibNamed:kTimeLineTableViewCellId owner:self options:nil] lastObject];
    }

    cell.indexPath = indexPath;
    cell.iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPersonalClick:)];
    [cell.iconView addGestureRecognizer:singleTap1];
    if (indexPath.row == self.dataArray.count-1) {
        cell.lineLab.hidden = YES;
    }else{
        cell.lineLab.hidden = NO;
    }
    cell.shareCellView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick:)];
    [cell.shareCellView addGestureRecognizer:singleTap0];
    cell.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewClick:)];
    [cell addGestureRecognizer:singleTap01];
    cell.contentLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longLabelPress:)];
    longPressGR.minimumPressDuration = 1;
    [cell.contentLabel addGestureRecognizer:longPressGR];
    
    __weak typeof(self) weakSelf = self;
    if (!cell.more1ButtonClickedBlock) {
        [cell setMore1ButtonClickedBlock:^(NSIndexPath *indexPath) {
            TRZXFriendLineCellModel *model = weakSelf.dataArray[indexPath.row];
            if (model.issOpening) {
                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            model.issOpening = !model.issOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
        
        [cell setDidClick1CommentLabelBlock:^(NSString *commentId,NSString *commentName,NSString *parentId,NSString *mid,NSString *comment, CGRect rectInWindow, NSIndexPath *indexPath) {
            if ([commentId isEqualToString:_selfIDStr]) {//默认的自己的ID判断
                weakSelf.currentEditingIndexthPath = indexPath;
//                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
//                _actionStr = @"1";
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
                weakSelf.commentToUserName = commentName;
                weakSelf.commentToUserID = commentId;
                [weakSelf adjustTableViewToFitKeyboardWithRect:rectInWindow];
            }
            
        }];
        
        [cell setDidClickCopyBlock:^(NSString *comment, CGRect rectInWindow){
            [_textField resignFirstResponder];
            [self becomeFirstResponder];
            _copStr = comment;
            TRZXFriendLineCell *cell = (TRZXFriendLineCell *)self.view;
            [cell becomeFirstResponder];
            UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyItemClicked:)];
            UIMenuController *menu = [UIMenuController sharedMenuController];
            [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
            [menu setTargetRect:rectInWindow inView:cell.superview];
            [menu setMenuVisible:YES animated:YES];
        }];
        
        [cell setDelete1ButtonClickedBlock:^(NSIndexPath *indexPath) {
            
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
        
        [cell  setTrzxPresentBlock:^(NSString *commentId) {
            [_textField resignFirstResponder];
//            PersonalInformationVC * studentPersonal=[[PersonalInformationVC alloc]init];
//            studentPersonal.otherStr = @"1";
//            studentPersonal.headBackStr = @"1";
//            studentPersonal.midStrr = [KPOUserDefaults userId];
//            [weakSelf.navigationController pushViewController:studentPersonal animated:true];
        }];
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
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

- (void)textChanged:(UITextField *)textfield
{
    if (textfield.text.length <=1500) {
    } else {
        NSString *subText = [textfield.text substringToIndex:1500];
        textfield.text = subText;
        _textField.text = subText;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_messagStr isEqualToString:@"0"]) {

        _messageView = [TRZXFriendMessageView new];
        [_messageView.bjIconImage sd_setImageWithURL:[NSURL URLWithString:_messagImgStr] placeholderImage:[UIImage imageNamed:@"首页头像"]];
        _messageView.titleLabel.text = _messagTitStr;
        _messageView.bgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageClick:)];
        [_messageView.bgview addGestureRecognizer:singleTap2];
        return _messageView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_messagStr isEqualToString:@"0"]) {
        return 50;
    }else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TRZXFriendLineCell class] contentViewWidth:[self cellContentViewWith]];
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


#pragma mark - TRZXFriendLineCellDelegate

- (void)didClick1cCommentButtonInCell:(UITableViewCell *)cell
{
    [_textField becomeFirstResponder];
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    __weak typeof(self) weakSelf = self;
    weakSelf.textField.placeholder = @"";
    [weakSelf.textField becomeFirstResponder];
    weakSelf.isReplayingComment = NO;
    weakSelf.commentToUserName = _selfNameStr;//默认自己的名字
    weakSelf.commentToUserID = _selfIDStr;//默认自己的ID
    [weakSelf adjustTableViewToFitKeyboard];
    
}

//点赞事件
- (void)didClick1LikeButtonInCell:(UITableViewCell *)cell
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
        [TRZXNetwork requestWithUrl:nil params:params method:POST cachePolicy:NetworkingReloadIgnoringLocalCacheData callbackBlock:^(id object, NSError *error) {
             if ([object[@"status_code"] isEqualToString:@"200"]) {
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
        
        if (self.isReplayingComment) {
            //回复
            userName = _selfNameStr;//默认自己的名字
            userId = _selfIDStr;//默认自己的id
            otherName = self.commentToUserName;
            otherId = self.commentToUserID;
            parenStr = self.commentIdStr;
            midStr = self.commentIdStr;
            typeStr = @"reply";
        } else {
            //评论
            userName = _selfNameStr;//默认自己的名字
            userId = _selfIDStr;//默认自己的id
            otherName = @"";
            otherId = @"";
            typeStr = @"comment";
            parenStr = @"";
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
                 TRZXFriendLikeModel * mod = [TRZXFriendLikeModel mj_objectWithKeyValues:data[@"data"]];
                 if (self.isReplayingComment) {
                     commentItemModel.firstUserName = _selfNameStr;//默认自己的名字
                     commentItemModel.firstUserId = _selfIDStr;//默认自己的id
                     commentItemModel.secondUserName = self.commentToUserName;
                     commentItemModel.secondUserId = self.commentToUserID;
                     commentItemModel.parentId = self.hfcommentStr;
                     commentItemModel.mid = self.commentIdStr;
                     commentItemModel.commentString = textField.text;

                     self.isReplayingComment = NO;
                 } else {
                     commentItemModel.firstUserName = _selfNameStr;//默认自己的mingzi
                     commentItemModel.commentString = textField.text;
                     commentItemModel.mid = mod.mid;
                     commentItemModel.firstUserId = _selfIDStr;//默认自己的id
                 }
                 [temp addObject:commentItemModel];
                 model.commentItemsArray = [temp copy];
                 [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
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

-(void)setPhoto{
    
    if(imagePickerTag==201610310){
        
        //图片的请求先屏蔽
        
//        [TRZXFriendModelViews getTRZXFriendTopUpload:_selectedPhotos[0] otherId:_otherIdStr success:^(id object) {
//            [_selectedPhotos removeAllObjects];
//            [_selectedAssets removeAllObjects];
//            [_headerView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:object[@"file_url"]]];
//            _coverStr = object[@"file_url"];
//        } failure:^(NSError *error) {
//            
//        }];
    }else if (imagePickerTag==201610311){


        SendTimeLineViewController *sendTimeLineViewController = [[SendTimeLineViewController alloc] initWithSendTimeLineype:SendTimeLineypeImageText];
        sendTimeLineViewController.selectedPhotos= _selectedPhotos;
        sendTimeLineViewController.selectedAssets= _selectedAssets;
        __weak TRZXFriendLineTableViewController *weakSelf = self;
        sendTimeLineViewController.sendSuccessTimeLineBlock = ^(void){
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            _refrStr = @"0";
            _pageNo = 1;
            [weakSelf createData:weakSelf.pageNo refresh:0];
        };

        [self.navigationController pushViewController:sendTimeLineViewController animated:true];

        
    }
    
    
}

#pragma mark - ========================================相册相机图库操作详细介绍

#pragma mark - UIImagePickerController初始化

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


#pragma mark - ==============================访问相机

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
        }
    }
}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;  ///< 照片排列按修改时间升序
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        
                        
                        [self setPhoto];


                    }];
                }];
            }
        }];
    }
}


#pragma mark -
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    if (_photoMaxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_photoMaxCount columnNumber:4 delegate:self];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (_photoMaxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self setPhoto];
    

}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];

}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    imagePickerTag = actionSheet.tag;
    
    
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        if ([_actionStr isEqualToString:@"1"]) {
            
//            TRZXFriendLineCellModel *model = self.dataArray[_currentEditingIndexthPath.row];
//            NSMutableArray *temp = [NSMutableArray arrayWithArray:model.commentItemsArray];
//
//
//            [[Kipo_NetAPIManager sharedManager] request_Circle_Api_deletComment_mid:_commentIdStr andBlock:^(id data, NSError *error) {
//
//                if (data) {
//                    //删除评论事件
//                    TRZXFriendLineCellCommentItemModel *tempCommentModel = nil;
//                    for (TRZXFriendLineCellCommentItemModel *CommentModel in model.commentItemsArray) {
//                        if ([CommentModel.firstUserId isEqualToString:[KPOUserDefaults userId]]&&[CommentModel.commentString isEqualToString:_commentStr]) {
//                            tempCommentModel = CommentModel;
//                            break;
//                        }
//                    }
//                    [temp removeObject:tempCommentModel];
//                    model.commentItemsArray = [temp copy];
//                    [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
//
//                }
//                
//                
//            }];



            
        }else{
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            
            [self takePhoto];
        }
       
        
        
    } else if (buttonIndex == 1) {
        if ([_actionStr isEqualToString:@"1"]){
            
        }else{
            [self pushImagePickerController];

        }
        
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            if (alertView.tag == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
            }
        }
    }
}


//左侧按钮的返回
-(void)leftBarButtonItemPressed:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧按钮的跳转
-(void)rightBarButtonItemPressed:(UIButton *)button{
    [_textField resignFirstResponder];
    _photoMaxCount = 9;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    _actionStr = @"0";
    sheet.tag = 201610311;
#pragma clang diagnostic pop
    [sheet showInView:self.view];
}

#pragma mark - 发送文本
-(void)longPress:(UILongPressGestureRecognizer *) longPress{
    
    if ([longPress state] == UIGestureRecognizerStateBegan) {


        SendTimeLineViewController *sendTimeLineViewController = [[SendTimeLineViewController alloc] initWithSendTimeLineype:SendTimeLineypeText];
        sendTimeLineViewController.selectedPhotos= _selectedPhotos;
        sendTimeLineViewController.selectedAssets= _selectedAssets;
        __weak TRZXFriendLineTableViewController *weakSelf = self;
        sendTimeLineViewController.sendSuccessTimeLineBlock = ^(void){
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            _refrStr = @"0";
            _pageNo = 1;
            [weakSelf createData:weakSelf.pageNo refresh:0];

        };

        [self.navigationController pushViewController:sendTimeLineViewController animated:true];


    }

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
        
        TRZXFriendLineCell *cell = (TRZXFriendLineCell *)self.view;
        [cell becomeFirstResponder];
        UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyItemClicked:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:flag, nil]];
        [menu setTargetRect:rect inView:cell.superview];
        [menu setMenuVisible:YES animated:YES];

        
        return ;
    }
    
}

//新消息推送
- (void)messageClick:(UITapGestureRecognizer *)tap{
    DynamicHomeViewController * newMessage=[[DynamicHomeViewController alloc]init];
    newMessage.delegate = self;
    newMessage.navStr = @"1";
    newMessage.selfIconStr = self.selfIconStr;
    newMessage.selfNameStr = self.selfNameStr;
    newMessage.selfIDStr = self.selfIDStr;
    [self.navigationController pushViewController:newMessage animated:true];
    
}
-(void)pushload{
    _pageNo = 1;
    [self createData:self.pageNo refresh:0];
}
//切换封面
- (void)fengmianClick:(UITapGestureRecognizer *)tap
{
    
    _photoMaxCount = 1;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    _actionStr = @"0";
    sheet.tag = 201610310;
#pragma clang diagnostic pop
    [sheet showInView:self.view];
    
}
//分享的跳转
- (void)shareClick:(UITapGestureRecognizer *)tap{
    NSInteger indext = tap.view.tag-20161111;
    TRZXFriendLineCellModel *model = self.dataArray[indext];
    NSLog(@"点击的ID----%@---跳转到对应的页面",model.objId);
    UIViewController *TRZXFriendVC;

    if ([model.deleted isEqualToString:@"1"]) {//1删除
        //            [LCProgressHUD showFailure:@"该分享已经删除"];
        ShareDeleViewController *Controller = [ShareDeleViewController alloc];
        Controller.titleStr = @"内容已删除";
        [self.navigationController pushViewController:Controller animated:YES];
        
    }else{
        if ([model.type isEqualToString:@"course"]) {//在线课程
//            CourseDetailsViewController *player = [[CourseDetailsViewController alloc]init];
//            player.mid = model.objId;
//            player.type = 1;
//            TRZXFriendVC = player;
        }else if([model.type isEqualToString:@"otoSchool"]){//一对一
            
        }else if([model.type isEqualToString:@"project"]){//项目
           
        }else if([model.type isEqualToString:@"userHome"]){//个人主页
            
        }else if([model.type isEqualToString:@"investorHome"]){//投资人详情页
            
        }else if([model.type isEqualToString:@"bp"]){//bp
            //预览
           
        }else if([model.type isEqualToString:@"ResourcesReq"]){//发布的分享
           
        }else if([model.type isEqualToString:@"live"]){//直播
            
        }else if([model.type isEqualToString:@"exchange"]){//交易所
            
        }
    }
    [self.navigationController pushViewController:TRZXFriendVC animated:true];
}
//头像跳转
- (void)headPersonalClick:(UITapGestureRecognizer *)tap
{
    //跳转先屏蔽
    
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


@end
