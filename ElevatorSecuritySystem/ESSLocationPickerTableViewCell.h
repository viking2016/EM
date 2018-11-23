//
//  ESSLocationPickerTableViewCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationPickerController.h"

extern NSString *const EMALocationPickerTableViewCellName;

@interface ESSLocationPickerTableViewCell : UITableViewCell

@property (nonatomic, assign) LocationPickerStyle style;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@property (copy, nonatomic) void(^valueSelected)(NSDictionary *);

- (void)setStyle:(LocationPickerStyle)style
       labelText:(NSString *)labelText
 detailLabelText:(NSString *)detailLabelText
   valueSelected:(void(^)(NSDictionary *value))valueSelected;

@end
