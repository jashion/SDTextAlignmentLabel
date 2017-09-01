//
//  UILabel+SDTextAlignmentExtension.m
//  SDTextAlignmentLabel
//
//  Created by Jashion on 2017/8/30.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "UILabel+SDTextAlignmentExtension.h"
#import <objc/runtime.h>

@implementation UILabel (SDTextAlignmentExtension)

#pragma mark - Override methods
+ (void)load {
    Method originalMethod = class_getInstanceMethod([UILabel class], @selector(drawTextInRect:));
    Method swizzleMethod = class_getInstanceMethod([UILabel class], @selector(sd_drawTextInRect:));
    
    BOOL didAddMethod = class_addMethod([UILabel class], @selector(sd_drawTextInRect:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (didAddMethod) {
        class_replaceMethod([UILabel class], @selector(drawTextInRect:), method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

#pragma mark - Swizzle methods
- (void)sd_drawTextInRect:(CGRect)rect {
    CGRect textRect = [self textRectForBounds: rect limitedToNumberOfLines: self.numberOfLines];
    switch (self.sdTextAlignmentEX) {
        case SDTextAlignmentLeftTop:
        case SDTextAlignmentCenterTop:
        case SDTextAlignmentRightTop:
        case SDTextAlignmentJustifiedTop:
        case SDTextAlignmentNaturalTop:
        {
            textRect.origin.y = 0;
            break;
        }
            
        case SDTextAlignmentLeftBottom:
        case SDTextAlignmentCenterBottom:
        case SDTextAlignmentRightBottom:
        case SDTextAlignmentJustifiedBottom:
        case SDTextAlignmentNaturalBottom:
        {
            textRect.origin.y = rect.size.height - textRect.size.height;
            break;
        }
            
        default:
        {
            textRect = rect;
            break;
        }
    }
    [self sd_drawTextInRect: textRect];
}

#pragma mark - Custome methods
- (SDTextAlignment)sdTextAlignmentEX {
    return [objc_getAssociatedObject(self, @selector(sdTextAlignmentEX)) integerValue];
}

- (void)setSdTextAlignmentEX:(SDTextAlignment)sdTextAlignmentEX {
    if (sdTextAlignmentEX <= 4) {
        self.textAlignment = (int)sdTextAlignmentEX;
    } else if (sdTextAlignmentEX > 4 && sdTextAlignmentEX <= 6) {
        self.textAlignment = NSTextAlignmentLeft;
    } else if (sdTextAlignmentEX > 6 && sdTextAlignmentEX <= 8) {
        self.textAlignment = NSTextAlignmentCenter;
    } else if (sdTextAlignmentEX > 8 && sdTextAlignmentEX <= 10) {
        self.textAlignment = NSTextAlignmentRight;
    } else if (sdTextAlignmentEX > 10 && sdTextAlignmentEX <= 12) {
        self.textAlignment = NSTextAlignmentJustified;
    } else if (sdTextAlignmentEX > 12 && sdTextAlignmentEX <= 14) {
        self.textAlignment = NSTextAlignmentNatural;
    }
    objc_setAssociatedObject(self, @selector(sdTextAlignmentEX), @(sdTextAlignmentEX), OBJC_ASSOCIATION_ASSIGN);
}

@end
