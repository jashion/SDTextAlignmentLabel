//
//  SDTextAlignmentLabel.m
//  SDTextAlignmentLabel
//
//  Created by Jashion on 2017/8/30.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "SDTextAlignmentLabel.h"

@implementation SDTextAlignmentLabel

#pragma mark - Override methods
- (void)drawTextInRect:(CGRect)rect {
    CGRect textRect = [self textRectForBounds: rect limitedToNumberOfLines: self.numberOfLines];
    switch (self.sdTextAlignment) {
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
    [super drawTextInRect: textRect];
}

#pragma mark - Custome methods
- (void)setSdTextAlignment:(SDTextAlignment)sdTextAlignment {
    if (sdTextAlignment <= 4) {
        self.textAlignment = (int)sdTextAlignment;
    } else if (sdTextAlignment > 4 && sdTextAlignment <= 6) {
        self.textAlignment = NSTextAlignmentLeft;
    } else if (sdTextAlignment > 6 && sdTextAlignment <= 8) {
        self.textAlignment = NSTextAlignmentCenter;
    } else if (sdTextAlignment > 8 && sdTextAlignment <= 10) {
        self.textAlignment = NSTextAlignmentRight;
    } else if (sdTextAlignment > 10 && sdTextAlignment <= 12) {
        self.textAlignment = NSTextAlignmentJustified;
    } else if (sdTextAlignment > 12 && sdTextAlignment <= 14) {
        self.textAlignment = NSTextAlignmentNatural;
    }
    _sdTextAlignment = sdTextAlignment;
}

@end
