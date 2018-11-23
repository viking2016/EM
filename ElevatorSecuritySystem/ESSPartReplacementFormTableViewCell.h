//
//  ESSPartReplacementFormTableViewCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/7/5.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESSRepairModel.h"

@interface ESSPartReplacementFormTableViewCell : UITableViewCell

@property (strong, nonatomic) ESSPartReplacemenModel *model;

@property (weak, nonatomic) IBOutlet UITextField *partsTf;
@property (weak, nonatomic) IBOutlet UITextField *brandTf;
@property (weak, nonatomic) IBOutlet UITextField *modelTf;
@property (weak, nonatomic) IBOutlet UITextField *numberTf;
@property (weak, nonatomic) IBOutlet UITextField *unitPriceTf;
@property (copy, nonatomic) void(^deleteBtnClicked)(void);
@property (copy, nonatomic) void(^textFieldTextChanged)(ESSPartReplacemenModel *model);

@end
