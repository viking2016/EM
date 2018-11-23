//
//  ESSProgressView.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/22.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSProgressView.h"

static const CGFloat height = 12;
static const CGFloat count = 15;
static const CGFloat margin = 1;
static const CGFloat textWidth = 30;

@implementation ESSProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat h = height;
    CGFloat w = height * count + margin * count + textWidth;
    
    self.backgroundColor = ClearColor;
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    self = [super initWithFrame:CGRectMake(x, y, w, h)];
    if (self) {
        
    }
    return self;
}

- (void)updateWithCurrent:(NSInteger)current {
    [self removeAllSubviews];
    
    if (current > 0&&current <= 15) {
        for (int i = 0; i < count; i ++) {
            UIView *square = [[UIView alloc] initWithFrame:CGRectMake(i * (height + 1), 0, height, height)];
            [self addSubview:square];
            UIColor *color = i < (15 - current) ? [UIColor groupTableViewBackgroundColor] : FlatSkyBlue;
            square.backgroundColor = ClearColor;
            square.layer.backgroundColor = color.CGColor;
        }
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(height * count + margin * count, 0, textWidth, height)];
        [self addSubview:lb];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textColor = FlatSkyBlue;
        lb.textAlignment = NSTextAlignmentRight;
        lb.text = [NSString stringWithFormat:@"%lu天",current];
    }
    else {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 225, self.height)];
        [self addSubview:lb];
        lb.font = [UIFont systemFontOfSize:12];
        lb.textAlignment = NSTextAlignmentLeft;
        UIColor *color;
        NSString *text;
        if (current < 0) {
            color = [UIColor redColor];
            text = @"该任务已超时，请尽快完成!";
        }
        else if(current == 999999){
            color = FlatGray;
            text = @"暂无维保数据";
        }
        else if(current > 15){
            color = FlatSkyBlue;
            text = @"维保时间大于15天";
        }
        else if(current == 0){
            color = FlatSkyBlue;
            text = @"今日维保";
        }
        
        lb.text = text;
        lb.textColor = color;
    }
}

@end
