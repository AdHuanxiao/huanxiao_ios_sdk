//
//  HXAdConfigCell.m
//  HuanxiaoAdsExample
//
//  广告配置单元格
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import "HXAdConfigCell.h"

#pragma mark - HXAdConfigCell

@implementation HXAdConfigCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont systemFontOfSize:15];
    self.valueLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    self.valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.valueLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.valueLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.valueLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.titleLabel.trailingAnchor constant:16],
    ]];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    self.titleLabel.text = title;
    self.valueLabel.text = value;
}

@end

#pragma mark - HXAdConfigInputCell

@implementation HXAdConfigInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:15];
    self.textField.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:self.textField];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.textField.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:16],
        [self.textField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.textField.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
    ]];
}

- (void)configureWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text {
    self.titleLabel.text = title;
    self.textField.placeholder = placeholder;
    self.textField.text = text;
}

@end

#pragma mark - HXAdConfigSwitchCell

@implementation HXAdConfigSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.switchControl = [[UISwitch alloc] init];
    self.switchControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchControl];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.switchControl.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.switchControl.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
    ]];
}

- (void)configureWithTitle:(NSString *)title isOn:(BOOL)isOn {
    self.titleLabel.text = title;
    self.switchControl.on = isOn;
}

- (void)switchValueChanged:(UISwitch *)sender {
    if (self.onValueChanged) {
        self.onValueChanged(sender.isOn);
    }
}

@end
