//
//  ESSNetworkingTool.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSNetworkingTool : NSObject

+ (void)GET:(nonnull NSString *)URLString
 parameters:(nullable NSDictionary *)parameters
    success:(nonnull void (^)(NSDictionary * _Nonnull responseObject))success;


+ (void)POST:(nonnull NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
     success:(nonnull void (^)(NSDictionary * _Nonnull responseObject))success;


+ (void)POST:(nonnull NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
      images:(nonnull NSDictionary *)images
     success:(nonnull void (^)(NSDictionary * _Nonnull responseObject))success;

@end
