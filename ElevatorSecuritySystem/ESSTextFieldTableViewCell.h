//
//  ESSTextFieldTableViewCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/8.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const EMATextFieldTableViewCellName;

@interface ESSTextFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (copy, nonatomic) void(^textFieldTextChanged)(NSString *);

- (void)setLabelText:(NSString *)labelText
       textFieldText:(NSString *)textFieldText
         placeholder:(NSString *)placeholder
        keyboardType:(UIKeyboardType)type
        textAlignment:(NSTextAlignment)alignment
textFieldTextChanged:(void(^)(NSString *value))textFieldTextChanged;

@end
