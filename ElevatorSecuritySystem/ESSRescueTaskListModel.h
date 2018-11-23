//
//  ESSRescueTaskListModel.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/2/2.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

/*
 Address = "\U5c71\U4e1c\U7701\U9752\U5c9b\U5e02\U9ec4\U5c9b\U533a\U6d4b\U8bd5\U5730\U57401";
AlarmOrderTaskID = 27;
CreateTime = "2018-11-19 09:36";
InnerNo = "3\U53f7\U697c1\U68af";
Lat = "36.105358";
Lng = "120.409445";
ProjectName = "(\U8bef\U5220)\U6d4b\U8bd5\U9879\U76ee1";
RescueLevel = "\U4e00\U7ea7\U6551\U63f4";
TaskState = "\U5df2\U53d6\U6d88";

*/


#import <Foundation/Foundation.h>

@interface ESSRescueTaskListModel : NSObject

//@property (nonatomic,assign)NSInteger RescueId;
@property (nonatomic,copy)NSString *Location;
//@property (nonatomic,copy)NSString *Lng;
//@property (nonatomic,copy)NSString *Lat;
//@property (nonatomic,copy)NSString *Address;
@property (nonatomic,copy)NSString *Type;
@property (nonatomic,copy)NSString *AlarmTime;
@property (nonatomic,copy)NSString *State;

//新版本
@property (nonatomic,copy)NSString *AlarmOrderTaskID;
@property (nonatomic,copy)NSString *CreateTime;
@property (nonatomic,copy)NSString *ProjectName;
@property (nonatomic,copy)NSString *InnerNo;
@property (nonatomic,copy)NSString *Address;
@property (nonatomic,copy)NSString *RescueLevel;
@property (nonatomic,copy)NSString *TaskState;
@property (nonatomic,copy)NSString *Lng;
@property (nonatomic,copy)NSString *Lat;








@end
