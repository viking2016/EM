//
//  ESSLiftDetailController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/4/20.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSLiftDetailController : UIViewController

@property (nonatomic, copy) NSString *ElevID;

- (instancetype)initWithElevID:(NSString *)elevID;

@end
