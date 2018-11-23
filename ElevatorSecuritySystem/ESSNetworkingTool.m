//
//  ESSNetworkingTool.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSNetworkingTool.h"
#import <AFNetworking.h>
#import "CocoaSecurity.h"
#import "Base64.h"

//#define URL_MAIN @"http://96333.intelevator.cn"
//#define URL_TEST @"http://96333.test.intelevator.cn"
//#define URL_TEST @"http://96333.demo.intelevator.cn"
#define URL_MAIN @"http://yw.intelevator.cn"
#define URL_TEST @"http://yw.intelevator.cn"

@implementation ESSNetworkingTool

+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary * _Nonnull))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[self createURLStringWithString:URLString] parameters:[self createParasWithDic:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [self decryptWithTask:task responseObject:responseObject];
        NSLog(@"------ \n url:%@ \n info:%@ \n", [self createURLStringWithString:URLString], dic);
        if ([dic[@"Err"] intValue] == 0) {
            [SVProgressHUD dismiss];
            success([NSDictionary replaceNullWithEmptyStringForObject:dic[@"Data"]]);
        }
        else if([dic[@"Err"] intValue] == 104){
            [SVProgressHUD showInfoWithStatus:@"登录失效，请重新登录"];
        [ESSLoginTool exitLogin];
        [ESSLoginTool showLoginController];
        }
        else {
            [SVProgressHUD showInfoWithStatus:dic[@"ErrMsg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"!!!ERROR!!! \n URL:%@",task.currentRequest);
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary * _Nonnull))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[self createURLStringWithString:URLString] parameters:[self createParasWithDic:parameters] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [self decryptWithTask:task responseObject:responseObject];
        NSLog(@"------ \n url:%@ \n info:%@ \n", URLString, dic);
        if ([dic[@"Err"] intValue] == 0) {
            [SVProgressHUD dismiss];
            success([NSDictionary replaceNullWithEmptyStringForObject:dic[@"Data"]]);
        }
        else if([dic[@"Err"] intValue] == 104){
            [SVProgressHUD showInfoWithStatus:@"登录失效，请重新登录"];
            [ESSLoginTool exitLogin];
            [ESSLoginTool showLoginController];
        }
        else {
            [SVProgressHUD showInfoWithStatus:dic[@"ErrMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"!!!ERROR!!! \n URL:%@",task.currentRequest);
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

/**
 上传图片POST请求
 @param parameters 字典，默认Token，Tel
 @param images 字典，key是规定命名，value是UIimage
 */
+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters images:(NSDictionary *)images success:(void (^)(NSDictionary * _Nonnull))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[self createURLStringWithString:URLString] parameters:[self createParasWithDic:parameters] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *name in images.allKeys) {
            NSData *imageData = UIImageJPEGRepresentation(images[name], 0.2);
            [formData appendPartWithFileData:imageData name:@"TuPian" fileName:name mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"url:%@ \n paras:%@ \n result:%@ \n", URLString, [self createParasWithDic:parameters], responseObject[responseObject[@"type"]]);
        NSDictionary *dic = [self decryptWithTask:task responseObject:responseObject];
        if ([dic[@"Err"] intValue] == 0) {
            [SVProgressHUD dismiss];
            success([NSDictionary replaceNullWithEmptyStringForObject:dic[@"Data"]]);
        }
        else if([dic[@"Err"] intValue] == 104){
            [SVProgressHUD showInfoWithStatus:@"登录失效，请重新登录"];
            [ESSLoginTool exitLogin];
            [ESSLoginTool showLoginController];
        }
        else {
            [SVProgressHUD showInfoWithStatus:dic[@"ErrMsg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
    }];
}

// 生成请求URL，可在登录页面长按logo选择正式地址或测试地址
+ (NSString *)createURLStringWithString:(NSString *)aString {
    NSString *mainURL = [ESSLoginTool isBate] ?
    URL_TEST : URL_MAIN;

    [[NSUserDefaults standardUserDefaults] setObject:mainURL forKey:@"mainURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return [mainURL stringByAppendingString:aString];
}

// 生成请求参数，默认Token,Tel
+ (NSDictionary *)createParasWithDic:(NSDictionary *)aDic {
    NSMutableDictionary *mDic = [NSMutableDictionary new];
    NSDictionary *loginInfo = [ESSLoginTool getLoginInfo];
    NSDictionary *userInfo = [ESSLoginTool getUserInfo];
    if (userInfo) {
        NSString *token = userInfo[@"Token"];
        [mDic setObject:token forKey:@"Token"];
    }
    if (loginInfo) {
        NSString *tel = loginInfo[@"YongHuMing"];
        [mDic setObject:tel forKey:@"YongHuMing"];
    }
    
    [mDic setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"UUID"];
    if (aDic) {
        [mDic addEntriesFromDictionary:aDic];
    }
    NSLog(@"传入参数 %@",mDic);
    return [NSDictionary dictionaryWithDictionary:mDic];
}

// 翻译错误码
+ (void)handleErrorCode:(NSString *)errorCode{
    NSString *info;
    switch ([errorCode intValue]) {
        case 0:
            info = @"ok";
            break;
        case 100:
            info = @"手机号未注册！";
            break;
        case 101:
            info = @"gai手机号已注册！";
            break;
        case 102:
            info = @"账户被冻结！";
            break;
        case 103:
            info = @"验证码不正确或已超时！";
            break;
        case 104:
            info = @"令牌超期！";
            [ESSLoginTool exitLogin];
            break;
        case 105:
            info = @"密码不正确！";
            break;
        case 106:
            info = @"手机号与绑定手机号不匹配！";
            break;
        case 107:
            info = @"没有权限！";
            break;
        case 108:
            info = @"账号有误！";
            break;
        case 109:
            info = @"单位编号有误！";
            break;
        case 177:
            info = @"短信发送间隔小于1分钟！";
            break;
        case 178:
            info = @"已超过短信发送次数！请1小时后再试！";
            break;
        case 179:
            info = @"已超过短信发送次数！请明天再试！";
            break;
        case 180:
            info = @"短信发送失败！";
            break;
        case 201:
            info = @"无该单位数据！";
            break;
        case 202:
            info = @"单位已存在!";
            break;
        case 901:
            info = @"参数不正确!";
            break;
        case 999:
            info = @"操作失败，请重试！";
            break;
        default:
            break;
    }
    [SVProgressHUD showErrorWithStatus:info];
}


// 数据解密
+ (NSDictionary *)decryptWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *allHeaders = response.allHeaderFields;
    NSString *originalKey = [allHeaders[@"sign"] stringByAppendingString:@"QDZXKJElEV"];
    NSString *key = [CocoaSecurity md5:originalKey].hex;
    NSString *originalString = responseObject[@"Result"];
    CocoaSecurityResult *result = [CocoaSecurity aesDecryptWithData:[originalString base64DecodedData] key:[key dataUsingEncoding:NSUTF8StringEncoding] iv:[[key substringToIndex:16] dataUsingEncoding:NSUTF8StringEncoding]];
    return [result.utf8String mj_JSONObject];
}


@end
