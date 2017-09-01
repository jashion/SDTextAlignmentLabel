//
//  ViewController.m
//  SDTextAlignmentLabel
//
//  Created by Jashion on 2017/8/30.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+SDTextAlignmentExtension.h"
#import "SDTextAlignmentLabel.h"
#import "UIButton+Extension.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *textAlignmentTypes;
@property (strong, nonatomic) IBOutlet UIButton *extensionButton;
@property (strong, nonatomic) IBOutlet UILabel *extensionLabel;

@property (strong, nonatomic) IBOutlet UIButton *subClassButton;
@property (strong, nonatomic) IBOutlet SDTextAlignmentLabel *subClassLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultConfigurationWithButton: self.extensionButton];
    [self defaultConfigurationWithLabel: self.extensionLabel];
    
    [self defaultConfigurationWithButton: self.subClassButton];
    [self defaultConfigurationWithLabel: self.subClassLabel];
    
    self.extensionLabel.text = @"我们来测试一下这些布局!(Extension)";
    self.subClassLabel.text = @"我们来测试一下这些布局!(SubClass)";
    
    [self.extensionButton addTarget: self action: @selector(handleClickExtensionButtonEvent:) forControlEvents: UIControlEventTouchUpInside];
    [self.subClassButton addTarget: self action: @selector(handleClickSubClassButtonEvent:) forControlEvents: UIControlEventTouchUpInside];
}

#pragma mark - Event response
- (void)handleClickExtensionButtonEvent: (UIButton *)button {
    static NSInteger index = 0;
    index += 1;
    self.extensionLabel.sdTextAlignmentEX = index;
    [self.extensionButton setTitle: self.textAlignmentTypes[index] forState: UIControlStateNormal];
    [self.extensionLabel setNeedsDisplay];
    if (index >= 14) {
        index = -1;
    }
}

- (void)handleClickSubClassButtonEvent: (UIButton *)button {
    static NSInteger index = 0;
    index += 1;
    self.subClassLabel.sdTextAlignment = index;
    [self.subClassButton setTitle: self.textAlignmentTypes[index] forState: UIControlStateNormal];
    [self.subClassLabel setNeedsDisplay];
    if (index >= 14) {
        index = -1;
    }
}

#pragma mark - Configuration
- (void)defaultConfigurationWithButton: (UIButton *)button {
    button.titleLabel.font = [UIFont systemFontOfSize: 15];
    button.layer.cornerRadius = 3;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [button setTitle: self.textAlignmentTypes[SDTextAlignmentLeft] forState: UIControlStateNormal];
}

- (void)defaultConfigurationWithLabel: (UILabel *)label {
    label.font = [UIFont systemFontOfSize: 16];
    label.textColor = [UIColor blackColor];
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    label.numberOfLines = 0;
}

#pragma mark - Custome methods
- (NSArray *)textAlignmentTypes {
    if (!_textAlignmentTypes) {
        _textAlignmentTypes = @[@"SDTextAlignmentLeft", @"SDTextAlignmentCenter", @"SDTextAlignmentRight",
                                @"SDTextAlignmentJustified", @"SDTextAlignmentNatural", @"SDTextAlignmentLeftTop", @"SDTextAlignmentLeftBottom", @"SDTextAlignmentCenterTop", @"SDTextAlignmentCenterBottom", @"SDTextAlignmentRightTop", @"SDTextAlignmentRightBottom", @"SDTextAlignmentJustifiedTop", @"SDTextAlignmentJustifiedBottom", @"SDTextAlignmentNaturalTop", @"SDTextAlignmentNaturalBottom"];
    }
    return _textAlignmentTypes;
}

@end
