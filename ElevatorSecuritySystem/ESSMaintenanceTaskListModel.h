//
//  ESSMaintenanceTaskListModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/9/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSMaintenanceTaskListModel : NSObject

@property (copy, nonatomic) NSString *LiftCode;
@property (copy, nonatomic) NSString *LiftType;
@property (copy, nonatomic) NSString *Address;
@property (copy, nonatomic) NSString *MType;
@property (copy, nonatomic) NSString *Date;
@property (copy, nonatomic) NSString *AllConfirm;
@property (copy, nonatomic) NSString *State;
@property (copy, nonatomic) NSString *ChaoQi;
@property (copy, nonatomic) NSString *TaskId;
@property (copy, nonatomic) NSString *MaintenanceNo;
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
//@property (copy, nonatomic) NSString *State;




@end
