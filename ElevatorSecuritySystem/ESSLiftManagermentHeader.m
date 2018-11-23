//
//  ESSLiftManagermentHeader.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/27.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "ESSLiftManagermentHeader.h"

@implementation ESSLiftManagermentHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

    self.background.layer.cornerRadius = 3;
    self.background.clipsToBounds = YES;
    self.background.userInteractionEnabled = NO;
    self.totalLb.layer.cornerRadius = self.totalLb.frame.size.width / 2;
    self.totalLb.clipsToBounds = YES;
    [self.currentLb.layer setCornerRadius:self.currentLb.frame.size.width / 2];
    self.currentLb.clipsToBounds = YES;
    self.logoLb.layer.cornerRadius = 5;
    self.logoLb.clipsToBounds = YES;

}

- (void)click:(id)sender {
    if (_click) {
        _click(sender);
    }
}

- (void)setUnitLbText:(NSString *)unit addressLbText:(NSString *)address totalLbText:(NSString *)total currentLbText:(NSString *)current clickBlock:(void (^)(id _Nonnull))block {
    
    NSArray *colors = @[rgb(102, 187, 227), rgb(237, 183, 107), rgb(145, 204, 153), rgb(200, 158, 169), rgb(238, 119, 133), rgb(132, 177, 237), rgb(121, 189, 154), rgb(170, 205, 110), rgb(253, 153, 154), rgb(247, 151, 93)];
    
    if (unit.length == 0) {
        unit = @"测试";
    }
    NSMutableString *mStr = [unit mutableCopy];
    CFStringTransform((CFMutableStringRef)mStr,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)mStr,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *tmpArr = [mStr componentsSeparatedByString:@" "];
    NSInteger index_0 = [tmpArr[0] characterAtIndex:0];
    NSInteger index;
    if (tmpArr.count > 1) {
        NSInteger index_1 = [tmpArr[1] characterAtIndex:0];
        index = index_0 + index_1;
    }else {
        index = index_0;
    }
    
    self.logoLb.backgroundColor = colors[index%10];
    
    self.unitLb.text = unit;
    self.addressLb.text = address;
    self.totalLb.text = total;
    
    NSInteger num = [current integerValue];
    if (num > 0) {
        self.currentLb.text = current;
        self.currentLb.hidden = NO;
    }else{
        self.currentLb.hidden = YES;
    }

    self.logoLb.text = [unit substringToIndex:1];
    _click = block;
}

@end
