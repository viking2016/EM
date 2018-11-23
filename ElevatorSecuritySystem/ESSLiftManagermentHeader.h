//
//  ESSLiftManagermentHeader.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/27.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSLiftManagermentHeader : UIControl

NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *unitLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *totalLb;
@property (weak, nonatomic) IBOutlet UILabel *currentLb;
@property (weak, nonatomic) IBOutlet UILabel *logoLb;
@property (copy, nonatomic) void(^click)(id sender);

- (void)setUnitLbText:(NSString *)unit
        addressLbText:(NSString *)address
          totalLbText:(NSString *)total
        currentLbText:(NSString *)current
           clickBlock:(void(^)(id sender))block;

NS_ASSUME_NONNULL_END

@end
