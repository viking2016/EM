//
//  ESSRescueTaskListController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/29.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRescueTaskListController : UIViewController

@property (nonatomic,copy) NSString *controllerType;
@property (nonatomic,copy) NSString *elevID;
- (instancetype)initWithControllerType:(NSString *)controllerType elevID:(NSString *)elevID;

@end
