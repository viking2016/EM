//
//  ESSMaintenanceItemsCell.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 16/11/29.
//  Copyright © 2016年 ZhengXinKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSMaintenanceItemsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *mainLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *dateLb;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (copy, nonatomic) void(^valueSelected)(NSString *);

- (void)setMainLbText:(NSString *)text
                 date:(NSString *)date
         detailLbText:(NSString *)detailText
               result:(NSString *)result
       valueSelected:(void(^)(NSString *value))valueSelected;
@end
