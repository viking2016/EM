//
//  ESSMaintenanceFormDetailModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/7/19.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Maintenanceresults;
@interface ESSMaintenanceFormDetailModel : NSObject

@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *CreateUserId;
@property (nonatomic, copy) NSString *SecurityPersonTel;
@property (nonatomic, copy) NSString *UserUnit;
@property (nonatomic, copy) NSString *MaintenanceNo;
@property (nonatomic, copy) NSString *InstallDate;
//@property (nonatomic, strong) NSArray<Maintenanceresults *> *MaintenanceResults;
//@property (nonatomic, copy) NSString *MPersonName;
@property (nonatomic, copy) NSString *Manufacture;
@property (nonatomic, copy) NSString *SecurityPerson;
@property (nonatomic, copy) NSString *MType;
@property (nonatomic, copy) NSString *MaintenanceUnit;
@property (nonatomic, copy) NSString *ModifyUserId;
@property (nonatomic, copy) NSString *Sign;
@property (nonatomic, copy) NSString *LiftBrand;
//@property (nonatomic, copy) NSString *LoadWeight;
@property (nonatomic, copy) NSString *ServiceAttitude;
@property (nonatomic, copy) NSString *AuditDate;
@property (nonatomic, copy) NSString *PPrincipalTel;
@property (nonatomic, copy) NSString *PropertyPrincipal;
@property (nonatomic, copy) NSString *LiftModel;
@property (nonatomic, copy) NSString *SignTime;
@property (nonatomic, copy) NSString *AuditUserName;
@property (nonatomic, copy) NSString *TechnicalLevel;
@property (nonatomic, copy) NSString *AuditUserId;
@property (nonatomic, copy) NSString *SerialNo;
@property (nonatomic, copy) NSString *ModifyUserName;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *AuditSuggestion;
@property (nonatomic, copy) NSString *RegCode;
//@property (nonatomic, copy) NSString *MPrincipal;
@property (nonatomic, copy) NSString *LiftCode;
@property (nonatomic, copy) NSString *ArriveTime;
@property (nonatomic, copy) NSString *PropertyCompany;
@property (nonatomic, copy) NSString *MPersonCode;
//@property (nonatomic, copy) NSString *MPersonTel;
//@property (nonatomic, copy) NSString *EPersonName;
@property (nonatomic, copy) NSString *EPersonCode;
//@property (nonatomic, copy) NSString *EPersonTel;
//@property (nonatomic, copy) NSString *Speed;
//@property (nonatomic, copy) NSString *MPrincipalTel;
@property (nonatomic, copy) NSString *ModifyDate;
@property (nonatomic, assign) NSInteger State;
@property (nonatomic, copy) NSString *CreateUserName;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *FinishTime;
@property (nonatomic, copy) NSString *LiftAddress;
//改变
@property (nonatomic, copy) NSString *UseTime;
@property (nonatomic, copy) NSString *BeginTime;
@property (nonatomic, copy) NSString *ElevNo;
@property (nonatomic, copy) NSString *InnerNo;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, copy) NSString *ManufactureName;
@property (nonatomic, copy) NSString *BrandName;
@property (nonatomic, copy) NSString *SeriesName;
@property (nonatomic, copy) NSString *ModelName;
@property (nonatomic, copy) NSString *RegNo;
@property (nonatomic, copy) NSString *Speed;
@property (nonatomic, copy) NSString *LoadWeight;
@property (nonatomic, copy) NSString *AddressDetail;
@property (nonatomic, copy) NSString *UUnitName;
@property (nonatomic, copy) NSString *Principal;
@property (nonatomic, copy) NSString *PrincipalTel;
@property (nonatomic, copy) NSString *SafetyManagerName;
@property (nonatomic, copy) NSString *SafetyManagerTel;
@property (nonatomic, copy) NSString *MUnitName;
@property (nonatomic, copy) NSString *MPrincipal;
@property (nonatomic, copy) NSString *MPrincipalTel;
@property (nonatomic, copy) NSString *MPersonName;
@property (nonatomic, copy) NSString *MPersonTel;
@property (nonatomic, copy) NSString *EPersonName;
@property (nonatomic, copy) NSString *EPersonTel;
@property (nonatomic, strong) NSArray<Maintenanceresults *> *Results;






@end

@interface Maintenanceresults : NSObject

@property (nonatomic, copy) NSString *RepairApplyNo;
@property (nonatomic, copy) NSString *Item;
@property (nonatomic, copy) NSString *MaintenanceNo;
@property (nonatomic, copy) NSString *RepairNo;
//@property (nonatomic, copy) NSString *Result;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString *ItemCode;

//改变
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, copy) NSString *GXBM;
@property (nonatomic, copy) NSString *GXDW;
@property (nonatomic, copy) NSString *GXRID;
@property (nonatomic, copy) NSString *GXRQ;
@property (nonatomic, copy) NSString *MCategory;
@property (nonatomic, copy) NSString *MTaskID;
@property (nonatomic, copy) NSString *MUnitID;
@property (nonatomic, copy) NSString *Num;
@property (nonatomic, copy) NSString *Position;
@property (nonatomic, copy) NSString *Requirement;
@property (nonatomic, copy) NSString *Result;
@property (nonatomic, copy) NSString *TJBM;
@property (nonatomic, copy) NSString *TJDW;
@property (nonatomic, copy) NSString *TJRID;
@property (nonatomic, copy) NSString *TJRQ;
@property (nonatomic, copy) NSString *TaskResultID;






@end

