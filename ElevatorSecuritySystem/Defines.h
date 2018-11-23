//
//  Defines.h
//  ElevatorSecuritySystem
//
//  Created by 刘树龙 on 2017/4/7.
//  Copyright © 2017年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#ifndef Defines_h
#define Defines_h


//获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//宏
#define SYSFONT [UIFont systemFontOfSize:14]

//主颜色
#define MAINCOLOR RGBA(26, 172, 239, 1)

//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//测试打印
#ifdef DEBUG
#define EMALog(...) NSLog(__VA_ARGS__)
#else
#define EMALog(...)
#endif

#endif /* Defines_h */
