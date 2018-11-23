//
//  ESSMessageListModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/5/26.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSMessageListModel : NSObject

/*
 Alias = 190e35f7e0439f08064;
 CreateTime = "2018-04-12 15:43:15";
 InfoType = "\U7ef4\U4fdd\U6d88\U606f";
 IsSlient = 0;
 PushContent = "\U8fd1\U4e09\U5929\U5171\U67092\U90e8\U7535\U68af\U5f85\U7ef4\U4fdd\Uff01";
 PushID = 17;
 PushTitle = "\U8fd1\U4e09\U5929\U5171\U67092\U90e8\U7535\U68af\U5f85\U7ef4\U4fdd\Uff01";
 isRead = 0;
 */

@property (nonatomic, copy) NSString *Alias;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *InfoType;
@property (nonatomic, copy) NSString *IsSlient;
@property (nonatomic, copy) NSString *PushContent;
@property (nonatomic, copy) NSString *PushID;
@property (nonatomic, copy) NSString *ToUserId;
@property (nonatomic, copy) NSString *PushTitle;
@property (nonatomic, copy) NSString *isRead;

@end
