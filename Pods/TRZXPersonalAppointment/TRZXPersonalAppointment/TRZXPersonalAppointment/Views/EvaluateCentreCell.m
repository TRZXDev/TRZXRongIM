//
//  EvaluateCentreCell.m
//  tourongzhuanjia
//
//  Created by 移动微 on 15/12/9.
//  Copyright © 2015年 JWZhang. All rights reserved.
//

#import "EvaluateCentreCell.h"

@implementation EvaluateCentreCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.FeedBtn.hidden = YES;
}

- (void)setMode:(MeetModel *)mode
{
    self.remarkText.text = mode.commentContent;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)Feedback:(id)sender {
    [self.delegate feedbackDelegate];
}
@end
