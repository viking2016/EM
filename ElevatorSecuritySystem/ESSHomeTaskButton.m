//
//  ESSHomeTaskButton.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/19.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSHomeTaskButton.h"

@implementation ESSHomeTaskButton

+ (instancetype)buttonWithNumber:(NSString *)number name:(NSString *)name {
    ESSHomeTaskButton *button = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ESSHomeTaskButton class]) owner:self options:nil] lastObject];
    button.numberLabel.layer.cornerRadius = 3;
    button.numberLabel.layer.borderWidth = 1;
    button.numberLabel.layer.borderColor = rgb(229, 229, 229).CGColor;
    button.numberLabel.clipsToBounds = YES;
    
    button.numberLabel.text = number;
    button.nameLabel.text = name;
    return button;
}

@end
