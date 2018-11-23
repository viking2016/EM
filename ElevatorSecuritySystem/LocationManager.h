//
//  LocationManager.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/6/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end
