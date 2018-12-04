//
//  ZXInformationListCell.m
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/12/3.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import "ZXInformationListCell.h"

@implementation ZXInformationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.markImgView.layer.cornerRadius = self.markImgView.height / 2;
    self.markImgView.clipsToBounds = YES;
    self.markImgView.backgroundColor = [UIColor redColor];
    
}

- (void)setReadState:(NSString *)state content:(NSString *)content time:(NSString *)time {
    if ([state isEqualToString:@"1"]) {
        [self read];
    }
    self.lb.text = content;
    self.timeLb.text = time;
}

- (void)read {
    self.markImgView.backgroundColor = [UIColor greenColor];
}

@end
