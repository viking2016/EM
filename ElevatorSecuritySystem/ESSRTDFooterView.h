//
//  ESSRTDFooterView.h
//  ElevatorSecuritySystem
//
//  Created by cz q on 2018/3/8.
//  Copyright © 2018年 Qingdao Zhengxin Technology Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSRTDFooterView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *zheDieBtn;

@property (nonatomic,strong) NSString *controllerType;
@property (nonatomic,strong) NSMutableArray *dataArray;


//- (instancetype)initWithArray:(NSArray *)array;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary controllerType:(NSString *)controllerType;
@end
