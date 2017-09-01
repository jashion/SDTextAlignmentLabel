//
//  UIButton+Extension.m
//  SDTextAlignmentLabel
//
//  Created by Jashion on 2017/9/1.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

+ (void)load {
    Method orginalMethod1 = class_getInstanceMethod([self class], @selector(touchesBegan:withEvent:));
    Method swizzleMetho1 = class_getInstanceMethod([self class], @selector(sd_touchesBegan:withEvent:));
    
    BOOL didAddMethod = class_addMethod([self class], @selector(sd_touchesBegan:withEvent:), method_getImplementation(orginalMethod1), method_getTypeEncoding(orginalMethod1));
    if (didAddMethod) {
        class_replaceMethod([self class], @selector(touchesEnded:withEvent:), method_getImplementation(swizzleMetho1), method_getTypeEncoding(swizzleMetho1));
    } else {
        method_exchangeImplementations(orginalMethod1, swizzleMetho1);
    }
    
    Method orginalMethod2 = class_getInstanceMethod([self class], @selector(touchesEnded:withEvent:));
    Method swizzleMethod2 = class_getInstanceMethod([self class], @selector(sd_touchesEnded:withEvent:));
    
    BOOL didAddMethod2 = class_addMethod([self class], @selector(sd_touchesEnded:withEvent:), method_getImplementation(orginalMethod2), method_getTypeEncoding(orginalMethod2));
    if (didAddMethod2) {
        class_replaceMethod([self class], @selector(touchesEnded:withEvent:), method_getImplementation(orginalMethod2), method_getTypeEncoding(orginalMethod2));
    } else {
        method_exchangeImplementations(orginalMethod2, swizzleMethod2);
    }
}

#pragma mark - 
- (void)sd_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sd_touchesBegan: touches withEvent: event];
    self.backgroundColor = [UIColor lightGrayColor];
    [self setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
}

- (void)sd_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self sd_touchesEnded: touches withEvent: event];
    [UIView animateWithDuration: 0.2 animations:^{
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    }];
}

#pragma mark - Custome methods
- (ButtonHighlightType)highlightType {
    return [objc_getAssociatedObject(self, @selector(highlightType)) unsignedIntegerValue];
}

- (void)setHighlightType:(ButtonHighlightType)highlightType {
    objc_setAssociatedObject(self, @selector(highlightType), @(highlightType), OBJC_ASSOCIATION_ASSIGN);
}

@end
