//
//  ESSMaintenanceTopView.m
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/7/4.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSMaintenanceTopView.h"

@implementation ESSMaintenanceTopView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setAddressStr:(NSString *)addressStr {
    _addressStr = addressStr;
    _addressLb.text = self.addressStr;
}

- (void)setInnerCodeStr:(NSString *)innerCodeStr {
    _innerCodeStr = innerCodeStr;
    _innerCodeLb.text = self.addressStr;
}
- (void)setNumStr:(NSString *)numStr {
    _numStr = numStr;
    _numLb.text = self.numStr;
}

- (void)setDurationStr:(NSString *)durationStr {
    _durationStr = durationStr;
    _durationLb.text = self.durationStr;
}

- (void)setLastDateStr:(NSString *)lastDateStr {
    _lastDateStr = lastDateStr;
    _lastDateLb.text = self.lastDateStr;
}




@end
