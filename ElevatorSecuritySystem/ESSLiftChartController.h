//
//  ESSLiftChartController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSLiftChartController : UIViewController

@property (nonatomic,strong) NSString *LiftCode;

- (NSInteger)judgeDateType:(NSString *)dateStr;

@end
