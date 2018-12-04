//
//  ZXInformationListModel.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/12/4.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXInformationListModel : NSObject

@property (nonatomic, copy) NSString *ReadState;
@property (nonatomic, copy) NSString *SendContent;
@property (nonatomic, copy) NSString *SendTime;
@property (nonatomic, copy) NSString *PushLogID;

@end

NS_ASSUME_NONNULL_END
