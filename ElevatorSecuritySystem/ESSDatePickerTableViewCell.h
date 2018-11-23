//
//  ESSDatePickerTableViewCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActionSheetDatePicker.h"

extern NSString *const EMADatePickerTableViewCellName;

@interface ESSDatePickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (strong, nonatomic)ActionSheetDatePicker *datePicker;
@property (copy, nonatomic) void(^valueSelected)(NSString *);

- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
   pickerDateFormate:(UIDatePickerMode)pickerDateFormate
     showDateFormate:(NSString *)showDateFormate
       valueSelected:(void(^)(NSString *value))valueSelected;


@end
