//
//  ESSStringPickerTableViewCell.h
//  ElevatorMaintenanceAssistant
//
//  Created by 刘树龙 on 17/3/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActionSheetStringPicker.h"

extern NSString *const EMAStringPickerTableViewCellName;

@interface ESSStringPickerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;

@property (strong, nonatomic)ActionSheetStringPicker *stringPicker;
@property (copy, nonatomic) void(^valueSelected)(NSString *, id);

- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
                 URL:(NSString *)URLStr
                 key:(NSString *)key
       valueSelected:(void(^)(NSString *value, id response))valueSelected;

- (void)setLabelText:(NSString *)labelText
     detailLabelText:(NSString *)detailLabelText
             strings:(NSArray *)strings
       valueSelected:(void(^)(NSString *value, id response))valueSelected;

@end
