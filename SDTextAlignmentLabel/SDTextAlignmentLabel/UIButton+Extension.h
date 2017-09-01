//
//  UIButton+Extension.h
//  SDTextAlignmentLabel
//
//  Created by Jashion on 2017/9/1.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonHighlightType) {
    ButtonHighlightDefault      =   0
};

@interface UIButton (Extension)

@property (nonatomic, assign) ButtonHighlightType highlightType;

@end
