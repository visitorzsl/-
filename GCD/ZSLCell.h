//
//  ZSLCell.h
//  GCD
//
//  Created by 大大赵 on 2017/9/19.
//  Copyright © 2017年 赵世礼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSLCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//准备封装直接调用
@property (nonatomic, copy)NSString *cellID;
+ (ZSLCell *)initWith:(UITableView *)tableView;
@end
