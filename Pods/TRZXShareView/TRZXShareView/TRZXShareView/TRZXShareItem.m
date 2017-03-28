//
//  TRZXShareItem.m
//  
//
//  Created by ZZY on 16/3/28.
//
//

#import "TRZXShareItem.h"

@implementation TRZXShareItem

+ (instancetype)itemWithTitle:(NSString *)title
                         icon:(NSString *)icon
                     handler:(void (^)())handler
{
    TRZXShareItem *item = [[TRZXShareItem alloc] init];
    item.title = title;
    item.icon = icon;
    item.selectionHandler = handler;
    
    return item;
}

@end
