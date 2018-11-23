//
//  ESSHomeTaskButton.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/19.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSHomeTaskButton : UIButton

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)buttonWithNumber:(NSString *)number name:(NSString *)name;

@end
