//
//  ZXWebController.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/11.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXWebController : UIViewController

- (instancetype)initWithURLStr:(NSString *)URLStr;

- (instancetype)initWithURLStr:(NSString *)URLStr viewWillDisappear:(void(^)(void))block;

@end

