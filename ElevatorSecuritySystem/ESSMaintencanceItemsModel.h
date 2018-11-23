//
//  ESSMaintencanceItemsModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/12/1.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESSMaintencanceItemsModel : RLMObject

@property NSString *taskId;
@property NSString *dataArr;

@end

RLM_ARRAY_TYPE(ESSMaintencanceItemsModel)
