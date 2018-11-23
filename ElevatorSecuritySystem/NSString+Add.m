//
//  NSString+Add.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

- (BOOL)judgeByPredicateString:(NSString *)predicateString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateString];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isId
{
    NSString *predicateString = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$";
    return [self judgeByPredicateString:predicateString];
}

- (BOOL)isPhoneNumber {
    NSString *predicateString = @"^[1][34578]\\d{9}";
    return [self judgeByPredicateString:predicateString];
}

- (BOOL)isNumber {
    NSString *predicateString = @"[0-9]*";
    return [self judgeByPredicateString:predicateString];
}

+ (NSString *)stringWithDateString:(NSString *)dateString format:(NSString *)dateFormat {
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z/()]" options:0 error:NULL];
    NSString *tmp = dateString;
    NSString *result = [regular stringByReplacingMatchesInString:tmp options:0 range:NSMakeRange(0, [dateString length]) withTemplate:@""];
    NSTimeInterval second = result.longLongValue/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSString *)replaceEmptyString:(NSString *)string {
    NSString *str;
    if ([string isKindOfClass:[NSNull class]]) {
        str = @" ";
    }else{
        if (!(string.length >0 )) {
            str = @"";
        }else{
            str = string;
        }
    }
    return str;
    
}
@end
