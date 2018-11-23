//
//  ESSMaintenanceTopView.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/7/4.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSMaintenanceTopView : UIView

@property (strong,nonatomic) NSString *addressStr;
@property (strong,nonatomic) NSString *innerCodeStr;
@property (strong,nonatomic) NSString *durationStr;
@property (strong,nonatomic) NSString *numStr;
@property (strong,nonatomic) NSString *lastDateStr;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *innerCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *durationLb;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UILabel *lastDateLb;

//+ (instancetype)aNewView;
//- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title images:(NSArray *)images;

//- (instancetype)init;

@end
