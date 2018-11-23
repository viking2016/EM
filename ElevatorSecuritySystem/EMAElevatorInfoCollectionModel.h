//
//  EMAElevatorInfoCollectionModel.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMAElevatorInfoCollectionModel : NSObject

@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *ProjectID;
@property (nonatomic, strong) NSString *Lng;
@property (nonatomic, strong) NSString *Lat;
@property (nonatomic, strong) NSString *ElevType;
@property (nonatomic, strong) NSString *RegNo;
@property (nonatomic, strong) NSString *InnerNo;
@property (nonatomic, strong) NSString *NextMMDate;
@property (nonatomic, strong) NSString *NextAnnualDate;

@end
