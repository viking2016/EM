//
//  ESSLiftManagerProjectModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/5/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSLiftManagerLiftDetailModel : NSObject

//@property (nonatomic, copy) NSString *Address;
//@property (nonatomic, copy) NSDictionary *AlarmMsg;
//@property (nonatomic, copy) NSString *InnerCode;
//@property (nonatomic, copy) NSString *IsAlarm;
//@property (nonatomic, copy) NSString *BasicInfo;
//@property (nonatomic, copy) NSString *MDate;
//@property (nonatomic, copy) NSString *MType;
//@property (nonatomic, copy) NSString *ProjectUnit;
//@property (nonatomic, copy) NSString *Type;
//@property (nonatomic, copy) NSString *Date;
//@property (nonatomic, copy) NSString *Days;
//
//@end
//
//@interface ESSLiftManagerProjectModel : NSObject
//
//@property (nonatomic, copy) NSString *Address;
//@property (nonatomic, copy) NSString *Alarm;
//@property (nonatomic, strong) NSArray<ESSLiftManagerLiftDetailModel *> *Items;
//@property (nonatomic, copy) NSString *ProjectUnit;
//@property (nonatomic, copy) NSString *Total;

//电梯编号
@property (nonatomic, copy) NSString *ElevID;
//内部编号
@property (nonatomic, copy) NSString *InnerNo;
//是否有报警 1表示报警 0表示无报警
@property (nonatomic, copy) NSString *IsAlarm;
//维保类型
@property (nonatomic, copy) NSString *MCategories;
//维保日期，格式为“2017-05-05”
@property (nonatomic, copy) NSString *Mdate;
//据今天多少天
@property (nonatomic, copy) NSString *Days;

@end

@interface ESSLiftManagerProjectModel : NSObject

@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *AlarmTotal;
@property (nonatomic, strong) NSArray<ESSLiftManagerLiftDetailModel *> *ElevItems;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *ElevTotal;

@end




