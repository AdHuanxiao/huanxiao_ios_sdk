//
//  HXAdConfigCell.h
//  HuanxiaoAdsExample
//
//  广告配置单元格
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 基础配置单元格

@interface HXAdConfigCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;

@end

#pragma mark - 输入框配置单元格

@interface HXAdConfigInputCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

- (void)configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text;

@end

#pragma mark - 开关配置单元格

@interface HXAdConfigSwitchCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, copy) void (^onValueChanged)(BOOL isOn);

- (void)configureWithTitle:(NSString *)title isOn:(BOOL)isOn;

@end
