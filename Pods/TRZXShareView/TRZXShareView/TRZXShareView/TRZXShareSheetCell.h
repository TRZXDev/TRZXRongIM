//
//  TRZXShareSheetCell.h
//  
//
//  Created by ZZY on 16/3/28.
//
//

#import <UIKit/UIKit.h>

@interface TRZXShareSheetCell : UITableViewCell

@property (nonatomic, strong) NSArray *itemArray;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
