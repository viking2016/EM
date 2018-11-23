//
//  ESSRescueMessageDetailController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/3/9.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRescueMessageDetailController : UIViewController

@property (nonatomic,copy) NSDictionary *userInfo;

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;

@end
