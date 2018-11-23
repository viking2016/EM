//
//  ESSLiftInfoCollectionController.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/8.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSLiftInfoCollectionController : UIViewController

@property (nonatomic, copy) NSString *regCode;

- (instancetype)initWithRegCode:(NSString *)regCode;

@end
