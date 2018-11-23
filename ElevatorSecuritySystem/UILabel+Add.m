//
//  UILabel+Add.m
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/26.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import "UILabel+Add.h"

@implementation UILabel (Add)

- (void)alignBothSides {
    [self layoutIfNeeded];
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName :self.font}
                                              context:nil].size;
    
    //计算字间距
    CGFloat margin = (self.frame.size.width - textSize.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    
    //修改默认字间距离
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeString addAttribute:(NSString *)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeString;
}


@end
