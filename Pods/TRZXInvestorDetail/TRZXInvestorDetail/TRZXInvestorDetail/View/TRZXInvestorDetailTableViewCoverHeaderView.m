//
//  TRZXInvestorDetailTableViewCoverHeaderView.m
//  TRZXInvestorDetail
//
//  Created by zhangbao on 2017/3/8.
//  Copyright © 2017年 TRZX. All rights reserved.
//

#import "TRZXInvestorDetailTableViewCoverHeaderView.h"
#import "TRZXInvestorDetailModel.h"
#import "TRZXInvestorDetailMacro.h"

@interface TRZXInvestorDetailTableViewCoverHeaderView()

@property (nonatomic, strong) UIImageView *investorImageView;

@property (nonatomic, strong) UIImageView *organizatioinImageView;

@property (nonatomic, strong) UILabel *orgTaglabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) YYLabel *companyLabel;

@property (nonatomic, assign) BOOL isSelectedInvestor;

@end

@implementation TRZXInvestorDetailTableViewCoverHeaderView

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithScrollView:scrollView];
    if (!self) return nil;
    
    self.collectButtonHidden = YES;
    
    _organizatioinImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _investorImageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    self.isSelectedInvestor = YES;
    
    return self;
}

- (void)addOwnViews
{
    [super addOwnViews];
    [self addSubview:self.investorImageView];
    [self addSubview:self.organizatioinImageView];
    [self addSubview:self.orgTaglabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.companyLabel];
}

- (void)layoutFrameOfSubViews
{
    [super layoutFrameOfSubViews];
    [_investorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX).offset(-10);
    }];
    
    [_organizatioinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_centerX).offset(10);
    }];
    
    [_orgTaglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_organizatioinImageView.mas_right);
        make.centerY.equalTo(_organizatioinImageView.mas_bottom);
        make.height.mas_equalTo(18);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(45);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    _companyLabel.numberOfLines = 0;
    [_companyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom);
    }];
}

- (void)receiveActions
{
    [super receiveActions];
    
    @weakify(self);
    [_investorImageView.gestureRecognizers.firstObject.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        
        [self headImageDidTop:YES];
    }];
    
    [_organizatioinImageView.gestureRecognizers.firstObject.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        
        [self headImageDidTop:NO];
    }];
}

- (void)headImageDidTop:(BOOL)isSelectedInvestor
{
    if (_isSelectedInvestor == isSelectedInvestor) return;
    self.isSelectedInvestor = isSelectedInvestor;
    
    if (self.currentSelectidIsInvestor) {
        self.currentSelectidIsInvestor(_isSelectedInvestor);
    }
    [self setModel:_model];
}

#pragma mark - <Setter/Getter>
- (void)setModel:(TRZXInvestorDetailModel *)model
{
    _model = model;
    
    self.coverImageUrl = model.topPic;
    
    self.title = model.data.realName;
    
    [_investorImageView sd_setImageWithURL:[NSURL URLWithString:model.data.head_img] placeholderImage:[UIImage imageNamed:@"Iocn_PlaceholderImage"]];
    
    [_organizatioinImageView sd_setImageWithURL:[NSURL URLWithString:model.data.logo] placeholderImage:[UIImage imageNamed:@"Iocn_PlaceholderImage"]];
    
    _nameLabel.text = model.data.realName;
    
    NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
    // 公司名称
    NSMutableAttributedString *companyAttribut = [[NSMutableAttributedString alloc] initWithString:model.data.organization];
    companyAttribut.yy_color = [UIColor whiteColor];
    companyAttribut.yy_font = [UIFont systemFontOfSize:14];
    companyAttribut.yy_alignment = NSTextAlignmentCenter;
    [attributedText appendAttributedString:companyAttribut];
    
    if (_isSelectedInvestor) {
        // 职位
        NSMutableAttributedString *positionAttribut = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@",%@", model.data.iposition]];
        positionAttribut.yy_color = [UIColor whiteColor];
        positionAttribut.yy_font = [UIFont systemFontOfSize:15];
        positionAttribut.yy_alignment = NSTextAlignmentCenter;
        [attributedText appendAttributedString:positionAttribut];
    }
    
    YYTextLayout *companyLayout = [YYTextLayout layoutWithContainer:[YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)] text:attributedText];
    
    _companyLabel.attributedText = attributedText;
    
    [_companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(companyLayout.textBoundingSize.height);
    }];
}

- (void)setIsSelectedInvestor:(BOOL)isSelectedInvestor
{
    if (_isSelectedInvestor == isSelectedInvestor) return;
    
    _isSelectedInvestor = isSelectedInvestor;
    
    _nameLabel.hidden = !isSelectedInvestor;
    
    _orgTaglabel.hidden = YES;
    
    [UIView animateWithDuration:0.8f animations:^{
        _organizatioinImageView.transform = isSelectedInvestor ? CGAffineTransformMakeScale(0.7, 0.7) : CGAffineTransformMakeScale(1.3, 1.3);
        _investorImageView.transform = isSelectedInvestor ?  CGAffineTransformMakeScale(1.3, 1.3) : CGAffineTransformMakeScale(0.7, 0.7);
        
    } completion:^(BOOL finished) {
        
        CGPoint point  = CGPointMake(CGRectGetMaxX(_organizatioinImageView.frame), CGRectGetMaxY(_organizatioinImageView.frame));
        _orgTaglabel.center = point;
        
        _orgTaglabel.hidden = isSelectedInvestor;
    }];
    
}

- (UIImageView *)investorImageView
{
    if (!_investorImageView) {
        _investorImageView = [[UIImageView alloc] init];
        _investorImageView.clipsToBounds = YES;
        _investorImageView.layer.cornerRadius = 6;
        [_investorImageView addGestureRecognizer:[UITapGestureRecognizer new]];
        _investorImageView.userInteractionEnabled = YES;
    }
    return _investorImageView;
}

- (UIImageView *)organizatioinImageView
{
    if (!_organizatioinImageView) {
        _organizatioinImageView = [[UIImageView alloc] init];
        _organizatioinImageView.clipsToBounds = YES;
        _organizatioinImageView.layer.cornerRadius = 6;
        [_organizatioinImageView addGestureRecognizer:[UITapGestureRecognizer new]];
        _organizatioinImageView.userInteractionEnabled = YES;
    }
    return _organizatioinImageView;
}

- (UILabel *)orgTaglabel
{
    if (!_orgTaglabel) {
        _orgTaglabel = [[UILabel alloc] init];_orgTaglabel.text = @" 投资机构 ";
        _orgTaglabel.font = [UIFont systemFontOfSize:13];
        _orgTaglabel.textColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1];
        _orgTaglabel.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:0/255.0 blue:15.0/255.0 alpha:1].CGColor;
        _orgTaglabel.layer.borderWidth = 0.5;
        _orgTaglabel.layer.cornerRadius = 6;
        _orgTaglabel.layer.masksToBounds = YES;
        [_orgTaglabel sizeToFit];
        _orgTaglabel.hidden = YES;
    }
    return _orgTaglabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor trzx_colorWithHexString:@"#EFEFF4"];
        _nameLabel.hidden = YES;
    }
    return _nameLabel;
}

- (YYLabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[YYLabel alloc] init];
    }
    return _companyLabel;
}

@end
