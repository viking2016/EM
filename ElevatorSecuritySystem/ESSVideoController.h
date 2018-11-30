//
//  ESSVideoController.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2017/5/17.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSVideoController : UIViewController
{
    __weak IBOutlet UIView *videoView;
}

@property (nonatomic,copy)NSString *ElevID;

@end
