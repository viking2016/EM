//
//  RescueTaskModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/8/15.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RescueTaskModel : NSObject

@property (nonatomic, copy) NSString *MPersonTel;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *SafetyManagerName;

@property (nonatomic, assign) NSInteger State;

@property (nonatomic, assign) NSInteger IsSecondRescue;

@property (nonatomic, copy) NSString *CreateDate;

@property (nonatomic, copy) NSString *MPerson;

@property (nonatomic, copy) NSString *EPersonTel;

@property (nonatomic, copy) NSString *SafetyManagerTel;

@property (nonatomic, copy) NSString *LiftAddress;

@property (nonatomic, copy) NSString *EPerson;

@property (nonatomic, copy) NSString *AlarmNo;

@end
