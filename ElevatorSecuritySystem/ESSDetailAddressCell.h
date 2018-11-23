//
//  ESSDetailAddressCell.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/8/31.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ESSDetailAddressCellName;


@interface ESSDetailAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *leftTF;
@property (weak, nonatomic) IBOutlet UITextField *rightTF;

@property (copy, nonatomic) void(^detailTextFieldTextChanged)(NSString *,NSString *);


- (void)setLabelText:(NSString *)labelText
       leftTextFieldText:(NSString *)leftTextFieldText
   rightTextFieldText:(NSString *)rightTextFieldText
detailTextFieldTextChanged:(void(^)(NSString *leftValue,NSString *rightValue))detailTextFieldTextChanged;

@end
