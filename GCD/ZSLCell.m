//
//  ZSLCell.m
//  GCD
//
//  Created by 大大赵 on 2017/9/19.
//  Copyright © 2017年 赵世礼. All rights reserved.
//

#import "ZSLCell.h"

@implementation ZSLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//封装 直接调用
+ (ZSLCell *)initWith:(UITableView *)tableView{
    static NSString *ID = @"cell";
    ZSLCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ZSLCell" owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
