//
//  ESSRepairModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/27.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSPartReplacemenModel : NSObject

@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *Parts;
@property (nonatomic, copy) NSString *Brand;
@property (nonatomic, copy) NSString *Model;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *UnitPrice;
@property (nonatomic, copy) NSString *Total;

@end

@interface ESSRepairModel : NSObject

@property (nonatomic, assign) int BasicInfoID;
@property (nonatomic, assign) int RepairID;
@property (nonatomic, copy) NSString *RepairNo;
@property (nonatomic, copy) NSString *LiftCode;
@property (nonatomic, copy) NSString *LiftType;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *RepairPerson;
@property (nonatomic, copy) NSString *RepairPersonTel;
@property (nonatomic, copy) NSString *RepairDate;
@property (nonatomic, copy) NSString *CallType;
@property (nonatomic, copy) NSString *Remark;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *FailureCause;
@property (nonatomic, copy) NSString *FailureCauseStr;
@property (nonatomic, strong) NSArray<NSString *> *FailureCauseAnalysis;
@property (nonatomic, strong) NSString *FailureCauseAnalysisStr;
@property (nonatomic, copy) NSString *MaintenanceRemark;
@property (nonatomic, strong) NSArray<ESSPartReplacemenModel *> *PartReplacemen;
@property (nonatomic, copy) NSString *TotalAmount;
@property (nonatomic, copy) NSString *IsCharge;
@property (nonatomic, copy) NSString *Result;
@property (nonatomic, copy) NSString *ProcessingResults;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *ServicePerson;
@property (nonatomic, copy) NSString *ServicePersonTel;
@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *FinishTime;
@property (nonatomic, copy) NSString *BeforePhoto;
@property (nonatomic, copy) NSString *AfterPhoto;
@property (nonatomic, copy) NSString *ServiceAttitude;
@property (nonatomic, copy) NSString *TechnicalLevel;
@property (nonatomic, copy) NSString *EvaluatorPerson;
@property (nonatomic, copy) NSString *EvaluatorDate;
@property (nonatomic, copy) NSString *EvaluatorRemark;
@property (nonatomic, strong) NSMutableArray<UIImage *> *preImages;
@property (nonatomic, strong) NSMutableArray<UIImage *> *edImages;

@end
