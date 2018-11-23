//
//  ESSMaintenanceFormDetailListModel.h
//  ElevatorSecuritySystem
//
//  Created by c zq on 16/11/21.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

/*
ElevNo = 000045;
ElevType = "\U5ba2\U68af";
FinishTime = "2018-11-16 10:11";
FinishYongHu = 15764222334;
InnerNo = "3\U53f7\U697c1\U68af";
IsChaoQi = "\U8d85\U671f";
MCategories = "\U5e74\U5ea6";
MTaskID = 32;
MaintenanceNo = 1800004501;
ProjectName = "(\U8bef\U5220)\U6d4b\U8bd5\U9879\U76ee1";
State = "\U5f85\U8bc4\U4ef7";
TaskDate = "2018-11-16";

*/




#import <Foundation/Foundation.h>

@interface ESSMaintenanceFormDetailListModel : NSObject

@property (copy, nonatomic) NSString *LiftCode;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *MType;
@property (copy, nonatomic) NSString *MaintenanceNo;
@property (copy, nonatomic) NSString *MTime ;
@property (copy, nonatomic) NSString *MPerson;
@property (copy, nonatomic) NSString *ChaoQi;
@property (copy, nonatomic) NSString *PJState;
@property (copy, nonatomic) NSString *WorkOrderID;

@property (copy, nonatomic) NSString *MTaskID;
@property (copy, nonatomic) NSString *ElevNo;
@property (copy, nonatomic) NSString *ElevType;
@property (copy, nonatomic) NSString *ProjectName;
@property (copy, nonatomic) NSString *InnerNo;
@property (copy, nonatomic) NSString *MCategories;
//@property (copy, nonatomic) NSString *MaintenanceNo;
@property (copy, nonatomic) NSString *TaskDate;
@property (copy, nonatomic) NSString *FinishTime;
@property (copy, nonatomic) NSString *ConfirmYongHuID;
@property (copy, nonatomic) NSString *IsChaoQi;
@property (copy, nonatomic) NSString *State;
@property (copy, nonatomic) NSString *FinishYongHu;
@end
