//
//  ESSLoginTool.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSLoginTool : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (BOOL)isBate;

+ (NSString *)getMainURL;

+ (void)autoLogin;

// 显示登录页面
+ (void)showLoginController;

// 检查登录状态
+ (BOOL)checkLoginState;

// 获取登录信息
+ (NSDictionary *)getLoginInfo;

// 获取头像url
+ (NSURL *)getProtraitURL;

// 获取用户姓名
+ (NSString *)getUserName;

// 获取用户信息
+ (NSDictionary *)getUserInfo;

// 登录
+ (void)loginWithLoginInfo:(nullable NSDictionary *)loginInfo success:(void(^ __nullable)(void))success;

// 退出登录
+ (void)exitLogin;

// 检查更新
+ (void)checkVersion;

+ (BOOL)isPersonalLogin;

NS_ASSUME_NONNULL_END

@end
