//
//  TRZXFriendLineTableHeaderView.m


#import "TRZXFriendLineTableHeaderView.h"

#import "UIView+SDAutoLayout.h"

#import "UIImageView+WebCache.h"

@implementation TRZXFriendLineTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _backgroundImageView = [UIImageView new];
//    _backgroundImageView.image = [UIImage imageNamed:@"TRZXBG"];
    [self addSubview:_backgroundImageView];
    
    _iconView = [UIImageView new];
//    [_iconView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:UserInfoImagePath]]];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.masksToBounds = YES;
    _iconView.tag = 20161025;
//    _iconView.layer.cornerRadius = 6.0;
    _iconView.layer.borderWidth = 2;
    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"";//默认自己的ID
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:_nameLabel];
    
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-130, 0, 40, 0));
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 20);
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
    
}

- (void)setModel:(TRZXFriendLineCellModel *)model{
    _model = model;
//    [_iconView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:UserInfoImagePath]]];
    _iconView.image = [UIImage imageNamed:@""];//默认的头像id
     [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImage] placeholderImage:[UIImage imageNamed:@"TRZXBG"]];
        _nameLabel.tag = 1000;
}

@end
