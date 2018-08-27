# SDTextAlignmentLabel
Extend label textAlignment type.

It is well known that label has five textAlignment types in iOS.You can not set text at top and center in label.
So, i want to extend label textAlignment types, actually has fifteen types.

>相对于iOS来说，UILabel系统只提供了五种样式，左右中等等，但是，内容相对于整个布局都是垂直居中的，想垂直居上和居下就不行，所以，自己搞了一个轮子。

### 实现的思路
`首先要获取文字的真正宽高，其次，绘制在屏幕之前需要改变文字的坐标，所以需要用到下面的函数：`
```
//获取真正的文字宽高
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
//将文字绘制在屏幕上
- (void)drawTextInRect:(CGRect)rect;
```
**第一种：子类实现**
```
\\子类布局类型
typedef NS_ENUM(NSInteger, SDTextAlignment) {
    SDTextAlignmentLeft             =   0,
    SDTextAlignmentCenter           =   1,
    SDTextAlignmentRight            =   2,
    SDTextAlignmentJustified        =   3,
    SDTextAlignmentNatural          =   4,
    SDTextAlignmentLeftTop          =   5,
    SDTextAlignmentLeftBottom       =   6,
    SDTextAlignmentCenterTop        =   7,
    SDTextAlignmentCenterBottom     =   8,
    SDTextAlignmentRightTop         =   9,
    SDTextAlignmentRightBottom      =   10,
    SDTextAlignmentJustifiedTop     =   11,
    SDTextAlignmentJustifiedBottom  =   12,
    SDTextAlignmentNaturalTop       =   13,
    SDTextAlignmentNaturalBottom    =   14
};
```
`新建一个子类，并添加一个SDTextAlignment类型枚举属性：`
```
@interface SDTextAlignmentLabel : UILabel

@property (nonatomic, assign) SDTextAlignment sdTextAlignment;

@end
```
`在sdTextAlignment 的set方法设值：`
```
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
```
`重写drawTextInRect：方法，重写布局：`
```
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
```
`这样和系统默认的布局不冲突，需要新的布局，只需要设置相应的sdTextAlignment类型就行。但是，毕竟是新的子类，如果旧的代码想用这个布局，代码修改量就有点大了，所以，想到了第二种实现方法，使用类别。`
**第二种：类别实现**
`新建一个类别，并关联sdTextAlignmentEX属性：`
```
@interface UILabel (SDTextAlignmentExtension)

@property (nonatomic, assign) SDTextAlignment sdTextAlignmentEX;

@end
```
`一样，在set方法里需要设置类型：`
```
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
```
`重点来了，需要重写load方法，然后hook系统的drawTextInRect:方法：`
```
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
```
`相应的，在hook的方法里重新布局：`
```
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
```
`效果显示：`
![Demo.gif](http://upload-images.jianshu.io/upload_images/968977-9e64d59a7a789c17.gif?imageMogr2/auto-orient/strip)
### 总结
**总的来说，使用类别实现修改的代码比较少，无侵入，使用子类，如果想修改旧代码就比较麻烦。但是，类别也不能滥用，一是类别的代码载入顺序不确定，和添加文件的顺序有关，二是，如果一个类的类别很多会大大加大加载时间，最好同一个类的类别写到一起。最后，给出[demo](https://github.com/jashion/SDTextAlignmentLabel)。**
