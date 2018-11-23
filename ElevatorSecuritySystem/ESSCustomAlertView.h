//
//  MyView.h
//  alertDemo
//
//  Created by cz q on 2018/7/7.
//  Copyright © 2018年 cz q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESSCustomAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;
@property (weak, nonatomic) IBOutlet UIButton *failBtn;
@property (weak, nonatomic) IBOutlet UITextField *contentLb;
@property (strong,nonatomic)UIButton * tmpBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, assign) NSInteger result;



//Block传值 先定义一个Block什么传值类型
@property(nonatomic,copy)void(^callBack)(NSDictionary *);


@end
