//
//  ESSLoginTool.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLoginTool.h"
#import "ESSLoginController.h"
#import "LocationManager.h"
#import <AFNetworking.h>
#import <JPUSHService.h>

#ifndef APP_ID
#define APP_ID @"1160815579"
#endif

#ifndef APP_STORE_URL
#define APP_STORE_URL @"http://itunes.apple.com/cn/lookup?id="APP_ID
#endif

#ifndef TO_APP_STORE
#define TO_APP_STORE @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="APP_ID
#endif

@implementation ESSLoginTool

#pragma mark - Public Method

+ (BOOL)isBate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isBate"];
}

+ (NSString *)getMainURL {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"mainURL"];
}

+ (void)autoLogin {
    if ([self checkLoginState]) {
        [self loginWithLoginInfo:[self getLoginInfo] success:^{
    }];
    }else {
        [[self class] showLoginController];
    }
}

+ (void)showLoginController {
    ESSLoginController *loginController = [[ESSLoginController alloc] init];
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController presentViewController:[[ESSNavigationController alloc] initWithRootViewController:loginController] animated:YES completion:^{
        
    }];
}

+ (BOOL)checkLoginState {
    return [[self class] getLoginInfo];
}

+ (NSDictionary *)getLoginInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginInfo"];
}

+ (NSDictionary *)getUserInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
}

+ (NSURL *)getProtraitURL {
    NSString *URLString = [[[self class] getUserInfo] objectForKey:@"Photo"];
    return [NSURL URLWithString:URLString];
}

+ (NSString *)getUserName {
    return [[[self class] getUserInfo] objectForKey:@"YongHuMing"];
}

+ (void)loginWithLoginInfo:(NSDictionary *)loginInfo success:(void (^)(void))success {
    if (!loginInfo) {return;}
    
    [SVProgressHUD show];
    [NetworkingTool POST:@"/APP/SYS/Sys_YongHu/Login" parameters:loginInfo success:^(NSDictionary * _Nonnull responseObject) {
        if (success) {
            NSLog(@"登录成功");
            [JPUSHService setAlias:loginInfo[@"PushID"] completion:nil seq:123];
            
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            // 开始定位
            //        [[LocationManager sharedInstance] startUpdatingLocation];
            // 保存用户信息
            [[NSUserDefaults standardUserDefaults] setObject:loginInfo forKey:@"loginInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"userInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getHomeData" object:nil];
            success();
        }
    }];
}

+ (void)exitLogin {
//    [[LocationManager sharedInstance] stopUpdatingLocation];

    [JPUSHService setAlias:@"" completion:nil seq:123];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self showLoginController];
}

+ (void)checkVersion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:APP_STORE_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"resultCount"] integerValue] > 0){
            NSDictionary *dict = [[responseObject objectForKey:@"results"] objectAtIndex:0];
            NSString *appStoreVersion = [dict objectForKey:@"version"];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *version = [infoDict objectForKey:@"CFBundleShortVersionString"];
            
            if ([self compareVersion:appStoreVersion to:version] > 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提醒" message:@"检测到有新的版本更新" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *update = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TO_APP_STORE]];
                                    exit(0);
                                }];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出应用" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            UIWindow *window = [UIApplication sharedApplication].delegate.window;
                
                            [UIView animateWithDuration:1.0f animations:^{
                                        window.alpha = 0;
                                    } completion:^(BOOL finished) {
                                        exit(0);
                                    }];
                                }];
                
                                [alert addAction:update];
                                [alert addAction:cancel];
                                
                [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 { // 都为空，相等，返回0
    if (!v1 && !v2) { return 0; } // v1为空，v2不为空，返回-1
    if (!v1 && v2) { return -1; } // v2为空，v1不为空，返回1
    if (v1 && !v2) { return 1; } // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."]; // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        
        if (value1 > value2) {
            return 1;
        }else if (value1 < value2){
            return -1;
        }
        //版本相等，继续循环
    }
    if (v1Array.count > v2Array.count) {
        return 1;
    }else if (v1Array.count < v2Array.count){
        return -1;
    }else{
        return 0;
    }
    return 0;
}

+ (BOOL)isPersonalLogin {
    NSString *roleType = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoleType"];
    return ![roleType boolValue];
}
#pragma mark - Privite Method

@end
