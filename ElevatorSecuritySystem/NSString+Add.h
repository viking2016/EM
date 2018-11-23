//
//  NSString+Add.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Add)

- (BOOL)isPhoneNumber;

- (BOOL)isId;

- (BOOL)isNumber;

- (BOOL)judgeByPredicateString:(NSString *)predicateString;

+ (NSString *)stringWithDateString:(NSString *)dateString format:(NSString *)dateFormat;

+ (NSString *)replaceEmptyString:(NSString *)string;


@end
