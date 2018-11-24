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
@property (nonatomic, copy) NSString *LiftCode;
@property (nonatomic, copy) NSString *LiftType;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *RepairPerson;
@property (nonatomic, copy) NSString *RepairPersonTel;
@property (nonatomic, copy) NSString *RepairDate;
@property (nonatomic, copy) NSString *CallType;
@property (nonatomic, copy) NSString *Remark;
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
@property (nonatomic, copy) NSString *EvaluatorRemark;
@property (nonatomic, strong) NSMutableArray<UIImage *> *preImages;
@property (nonatomic, strong) NSMutableArray<UIImage *> *edImages;
@property (nonatomic, copy) NSString *EvaluatorDate;


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
@property (nonatomic, copy) NSString *ReportContent;
@property (nonatomic, copy) NSString *ReportDate;
@property (nonatomic, copy) NSString *Reporter;
@property (nonatomic, copy) NSString *ReporterTel;
@property (nonatomic, copy) NSString *State;
@property (nonatomic, copy) NSString *ReporterTelTJRQ;
@property (nonatomic, copy) NSString *ReportType;

/*
 AfterPhoto = "";
 BeforePhoto = "";
 EvaluateDate = "2018-11-21 00:00:00";
 EvaluateRemark = "\U8be5\U5e7f\U544a";
 EvaluationSignURL = "";
 EvaluatorPerson = A37020280;
 FailureCause = ",";
 FailureCauseAnalysis = "\U751f\U6d3b\U5783\U573e\U5bfc\U81f4\U5f00\U5173\U95e8\U53d7\U963b\Uff0c\U7535\U68af\U505c\U6b62\U8fd0\U884c,";
 FinishTime = "2018-11-21 16:57:09";
 IsCharge = "\U662f";
 MaintenanceRemark = "\U54c8\U54c8\U54c8";
 PartReplacemen =     (
 );
 ProcessingResults = "\U62a5\U5e9f";
 RepairDate = "2018-11-21 00:00:00";
 RepairNo = 18000063003;
 RepairPerson = 2;
 RepairPersonTel = 22;
 ReportContent = 11111111111111111;
 ReportType = "\U6551\U63f4\U53ec\U4fee";
 Result = "";
 ScanningCopyPhoto = "";
 ServiceAttitude = "\U826f\U597d";
 ServicePerson = "\U9c7c\U4e00\U4e00";
 ServicePersonTel = 15764222334;
 StartTime = "2018-11-23 17:26:35";
 State = "\U7ef4\U4fee\U4e2d";
 TechnicalLevel = "\U826f\U597d";
 TotalAmount = "";
 TotalFee = "";
 */
//@property (nonatomic, copy) NSString *AfterPhoto;
//@property (nonatomic, copy) NSString *BeforePhoto;
//@property (nonatomic, copy) NSString *EvaluateDate;
//@property (nonatomic, copy) NSString *EvaluateRemark;
//@property (nonatomic, copy) NSString *EvaluationSignURL;
//@property (nonatomic, copy) NSString *EvaluatorPerson;
//@property (nonatomic, copy) NSString *FailureCause;
//@property (nonatomic, copy) NSString *FailureCauseAnalysis;
//@property (nonatomic, copy) NSString *IsCharge;
//@property (nonatomic, copy) NSString *MaintenanceRemark;
//@property (nonatomic, strong) NSArray<ESSPartReplacemenModel *> *PartReplacemen;
//@property (nonatomic, copy) NSString *ProcessingResults;
//@property (nonatomic, copy) NSString *Result;
//@property (nonatomic, copy) NSString *ServicePersonTel;
//@property (nonatomic, copy) NSString *ServiceAttitude;
//@property (nonatomic, copy) NSString *ServicePerson;
//@property (nonatomic, copy) NSString *ReportType;
//@property (nonatomic, copy) NSString *ReportType;

@end
