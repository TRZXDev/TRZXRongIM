//
//  EvaluateCentreCell.h
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetModel.h"
@protocol CellFeedbackDelegate <NSObject>

- (void)feedbackDelegate;

@end

@interface EvaluateCentreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *FeedBtn;
@property (weak, nonatomic) IBOutlet UILabel *CellTitleLable;
- (IBAction)Feedback:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *remarkText;
//@property (weak, nonatomic) IBOutlet UILabel *RemarkLable;
@property (weak, nonatomic) IBOutlet UIView *CellBackView;

@property (weak, nonatomic) id<CellFeedbackDelegate>delegate;

@property (strong, nonatomic) MeetModel *mode;

@end
