//
//  ESSRepairFormDetailHeader.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/13.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRepairFormDetailHeader : UITableViewHeaderFooterView

@property (copy, nonatomic) void(^callBack)(NSIndexPath *indexPath);
@property (strong, nonatomic) NSArray<NSArray *> *datas;

@end
