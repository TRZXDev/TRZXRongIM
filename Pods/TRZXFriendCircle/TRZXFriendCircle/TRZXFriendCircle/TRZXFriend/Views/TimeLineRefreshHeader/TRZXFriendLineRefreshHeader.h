//
//  TRZXFriendLineRefreshHeader.h



#import <UIKit/UIKit.h>
#import "SDBaseRefreshView.h"

@interface TRZXFriendLineRefreshHeader : SDBaseRefreshView


+ (instancetype)refreshHeaderWithTheCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();

@end
