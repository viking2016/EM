//
//  ESSSelectLiftController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/9/5.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSSelectLiftController : UIViewController

@property (nonatomic,copy) void(^liftCodeBlock)(NSString *, int);

@end
