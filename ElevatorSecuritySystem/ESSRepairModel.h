//
//  ESSRepairModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/6/27.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSPartReplacemenModel : NSObject

@property (nonatomic, copy) NSString *PartName;
@property (nonatomic, copy) NSString *PartPosition;
@property (nonatomic, copy) NSString *PartBrand;
@property (nonatomic, copy) NSString *PartModel;
@property (nonatomic, copy) NSString *Number;
@property (nonatomic, copy) NSString *UnitPrice;
@property (nonatomic, copy) NSString *Total;

@end

@interface ESSRepairModel : NSObject

/*
 {
 ElevID = 48;
 ElevNo = 000063;
 ElevType = "\U5ba2\U68af";
 InnerNo = "2\U53f7\U68af";
 IsDelete = 0;
 ProjectName = "\U5b59\U51ef\U5c0f\U533a1";
 RepairID = 42;
 RepairNo = 18000063003;
 Repairer = "\U9c7c\U4e00\U4e00";
 RepairerTel = 15764222334;
 ReportContent = 11111111111111111;
 ReportDate = "2018/11/21 0:00:00";
 Reporter = 2;
 ReporterTel = 22;
 State = "\U7ef4\U4fee\U4e2d";
 TJRQ = "2018-11-21 15:00";
 }
 */


// 维修任务列表
@property (nonatomic, assign) int ElevID;
@property (nonatomic, copy) NSString *ElevNo;
@property (nonatomic, copy) NSString *ElevType;
@property (nonatomic, copy) NSString *InnerNo;
@property (nonatomic, copy) NSString *IsDelete;
@property (nonatomic, copy) NSString *ProjectName;
@property (nonatomic, assign) int RepairID;
@property (nonatomic, copy) NSString *RepairNo;
@property (nonatomic, copy) NSString *Repairer;
@property (nonatomic, copy) NSString *RepairerTel;
@property (nonatomic, copy) NSString *RepairDate;
@property (nonatomic, copy) NSString *RepairContent;
@property (nonatomic, copy) NSString *Reporter;
@property (nonatomic, copy) NSString *ReporterTel;
@property (nonatomic, copy) NSString *ReportDate;
@property (nonatomic, copy) NSString *ReportContent;
@property (nonatomic, copy) NSString *State;

@property (nonatomic, copy) NSString *ReportType;

@property (nonatomic, copy) NSString *FailureCause;
@property (nonatomic, copy) NSString *FailureCauseAnalysis;
@property (nonatomic, strong) NSArray<ESSPartReplacemenModel *> *PartReplacemen;
@property (nonatomic, copy) NSString *TotalAmount;


@property (nonatomic, copy) NSString *IsCharge;
@property (nonatomic, copy) NSString *ElevState;
@property (nonatomic, copy) NSString *RepairResult;

@property (nonatomic, copy) NSString *StartTime;
@property (nonatomic, copy) NSString *FinishTime;

@property (nonatomic, copy) NSString *ServiceAttitude;
@property (nonatomic, copy) NSString *TechnicalLevel;
@property (nonatomic, copy) NSString *EvaluatorPerson;
@property (nonatomic, copy) NSString *EvaluatorDate;
@property (nonatomic, copy) NSString *EvaluatorRemark;

@property (nonatomic, copy) NSString *BeforePhoto;
@property (nonatomic, copy) NSString *AfterPhoto;

@end
