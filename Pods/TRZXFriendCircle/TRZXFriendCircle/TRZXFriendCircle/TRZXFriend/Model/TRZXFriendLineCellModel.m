//
//  TRZXFriendLineCellModel.m


#import "TRZXFriendLineCellModel.h"

#import <UIKit/UIKit.h>

extern const CGFloat contentLabelFontSize;
extern CGFloat max1ContentLabelHeight;

@implementation TRZXFriendLineCellModel
{
    CGFloat _lastContentWidth;
}

@synthesize msgContent = _msgContent;

- (void)setMsgContent:(NSString *)msgContent
{
    _msgContent = msgContent;
}

- (NSString *)msgContent
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_msgContent boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > max1ContentLabelHeight) {
            _should1ShowMoreButton = YES;
        } else {
            _should1ShowMoreButton = NO;
        }
    }
    
    return _msgContent;
}

- (void)setIsOpening:(BOOL)issOpening
{
    if (!_should1ShowMoreButton) {
        _issOpening = NO;
    } else {
        _issOpening = issOpening;
    }
}


@end

@implementation TRZXFriendShareItemModel


@end

@implementation TRZXFriendHeaderModel


@end

@implementation TRZXFriendLineCellLikeItemModel


@end


@implementation TRZXFriendLineCellCommentItemModel


@end
