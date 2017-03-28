//
//  TRZXFriendLineTableViewController.h


#import <UIKit/UIKit.h>

@interface TRZXFriendLineTableViewController : UITableViewController

@property (strong, nonatomic) NSString * otherIdStr;
@property (strong, nonatomic) NSString * userIdStr;

@property (nonatomic, copy) NSString * messagStr;
@property (nonatomic, copy) NSString * messagImgStr;
@property (nonatomic, copy) NSString * messagTitStr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIMenuItem * itemIT;
@property (nonatomic, strong) NSString *copStr;

@property (nonatomic, strong) NSString * selfNameStr;
@property (nonatomic, strong) NSString * selfIDStr;
@property (nonatomic, strong) NSString * selfIconStr;


@end
