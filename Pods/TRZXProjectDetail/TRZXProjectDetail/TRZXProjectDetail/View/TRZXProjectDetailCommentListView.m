//
//  TRZXProjectDetailCommentListView.m
//  TRZXProjectDetail
//
//  Created by zhangbao on 2017/3/9.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXProjectDetailCommentListView.h"
#import "TRZXProjectDetailModel.h"
#import "TRZXProjectDetailCommetListTableViewCell.h"
#import "TRZXProjectDetailMacro.h"

@interface TRZXProjectDetailCommentListView()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray <TRZXProjectDetailCommentModel *> *commentList;

@end

@implementation TRZXProjectDetailCommentListView

+ (TRZXProjectDetailCommentListView *)sharedCommentList
{
    TRZXProjectDetailCommentListView *commentList = nil;
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    for (id obj in nibs) {
        if ([obj isKindOfClass: [self class]]) {
            commentList = obj;
        }
    }

    return commentList;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TRZXProjectDetailCommetListTableViewCell class]) bundle:[NSBundle mainBundle]]forCellReuseIdentifier:@"TRZXProjectDetailCommetListTableViewCell"];
    
    // 自动计算cell高度
    _tableView.estimatedRowHeight = 80.0f;
    // iOS8 系统中 rowHeight 的默认值已经设置成了 UITableViewAutomaticDimension
    _tableView.rowHeight = UITableViewAutomaticDimension;

}

#pragma mark - <Public-Method>
- (void)dissMiss
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self setTransform:CGAffineTransformIdentity];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - <Private-Method>
- (IBAction)composeCloseButtonDidClick:(id)sender
{
    [self dissMiss];
}

- (TRZXProjectDetailCommentListView *)showCommentList:(NSArray <TRZXProjectDetailCommentModel *> *)commentList
{
    self.commentList = commentList;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(keyWindow);
        make.height.mas_equalTo(SCREEN_HEIGHT - 64);
        make.top.equalTo(keyWindow).offset(SCREEN_HEIGHT);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setTransform:CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT + 64)];
    } completion:^(BOOL finished) {
        
        [self.tableView reloadData];
    }];
    
    
    return self;
}

#pragma mark - <UITableViewDelegate/DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TRZXProjectDetailCommetListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TRZXProjectDetailCommetListTableViewCell"];
    cell.model = self.commentList[indexPath.row];
    
    return cell;
}

#pragma mark - <Setter/Getter>
- (NSArray<TRZXProjectDetailCommentModel *> *)commentList
{
    if (!_commentList) {
        _commentList = [[NSArray alloc] init];
    }
    return _commentList;
}

@end
