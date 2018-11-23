//
//  NSDictionary+Add.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/18.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "NSDictionary+Add.h"

@implementation NSDictionary (Add)

+ (NSDictionary *)deleteNullForDictionary:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    NSMutableDictionary *resultDic = [dic mutableCopy];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj = dic[key];
        [self replaceNullWithEmptyStringForObject:obj];
        [resultDic setObject:[self replaceNullWithEmptyStringForObject:obj] forKey:key];
    }];
    
    return [resultDic copy];
}

+ (NSArray *)deleteNullForArray:(NSArray *)arr
{
    NSMutableArray *resultArr = [arr mutableCopy];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultArr replaceObjectAtIndex:idx withObject:[self replaceNullWithEmptyStringForObject:obj]];
    }];
    return [resultArr copy];
}

+ (NSString *)deleteNullForString:(NSString *)string
{
    NSString *emptyStr = @"";
    if ([string isEqualToString:@" "]) {
        return emptyStr;
    }
    else if ([string isEqualToString:@"null"]) {
        return emptyStr;
    }
    else if ([string isEqualToString:@"&nbsp;"]) {
        return emptyStr;
    }
    return string;
}

+ (NSString *)nullToEmptyString
{
    return @"";
}

#pragma mark - Public Method
+ (id)replaceNullWithEmptyStringForObject:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        return [self deleteNullForDictionary:obj];
    }
    else if([obj isKindOfClass:[NSArray class]])
    {
        return [self deleteNullForArray:obj];
    }
    else if([obj isKindOfClass:[NSString class]])
    {
        return [self deleteNullForString:obj];
    }
    else if([obj isKindOfClass:[NSNull class]])
    {
        return [self nullToEmptyString];
    }
    else
    {
        return [NSString stringWithFormat:@"%@",obj];
    }
}

@end
