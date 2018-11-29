//
//  ESSImagePickerFlowLayout.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2018/11/28.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSImagePickerFlowLayout.h"

@implementation ESSImagePickerFlowLayout

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        CGFloat width = (SCREEN_WIDTH - 30 - 15) / 2;
        CGFloat height = width / 16 * 9;
        
        self.itemSize = CGSizeMake(width, height);
        self.minimumLineSpacing = 15;
        self.minimumInteritemSpacing = 15;
    }
    return self;
}

@end
