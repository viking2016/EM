//
//  ESSMessageListCell.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/12/15.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import "ESSMessageListCell.h"

@implementation ESSMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mark.layer.cornerRadius = self.mark.width/2;
    [self.mark.layer setMasksToBounds:YES];
    [self layoutIfNeeded];
}

@end
