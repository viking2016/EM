//
//  ESSSubmitController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/1/31.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSSubmitController : UIViewController

@property (nonatomic,copy)NSString *rescueId;

- (instancetype)initWithRescueId:(NSString *)rescueId;

@property(nonatomic,copy)void(^submitCallback)(NSString *);

@end
