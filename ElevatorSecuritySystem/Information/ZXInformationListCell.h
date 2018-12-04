//
//  ZXInformationListCell.h
//  ElevatorUnit
//
//  Created by 刘树龙 on 2018/12/3.
//  Copyright © 2018年 刘树龙. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXInformationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *markImgView;
@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

- (void)setReadState:(NSString *)state content:(NSString *)content time:(NSString *)time;
- (void)read;

@end

NS_ASSUME_NONNULL_END
