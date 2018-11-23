//
//  ESSRescueTaskListDetailController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/30.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRescueTaskListDetailController : UIViewController

@property (nonatomic,copy)NSString *AlarmOrderTaskID;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *controllerType;
- (instancetype)initWithAlarmOrderTaskID:(NSString *)alarmOrderTaskID rescueState:(NSString *)state controllerType:(NSString *)controllerType;


@end
