//
//  UIView+ZDHook.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2023/6/29.
//

#import "UIView+ZDHook.h"
#import <objc/runtime.h>

static const void *TouchExtendInsetKey = &TouchExtendInsetKey;

static void __Swizzle__(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIView (ZDHook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __Swizzle__(self, @selector(pointInside:withEvent:), @selector(_zd_pointInside:withEvent:));
    });
}

#pragma mark - TouchExtendInset

- (BOOL)_zd_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.zd_touchExtendInsets, UIEdgeInsetsZero) || self.hidden || self.alpha < 0.01 || !self.userInteractionEnabled) {
        return [self _zd_pointInside:point withEvent:event];
    }
    
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.zd_touchExtendInsets);
    hitFrame.size.width = MAX(hitFrame.size.width, 0);
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    BOOL result = CGRectContainsPoint(hitFrame, point);
    return result;
}

- (void)setZd_touchExtendInsets:(UIEdgeInsets)touchExtendInsets {
    objc_setAssociatedObject(self, TouchExtendInsetKey, [NSValue valueWithUIEdgeInsets:touchExtendInsets], OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)zd_touchExtendInsets {
    return [objc_getAssociatedObject(self, TouchExtendInsetKey) UIEdgeInsetsValue];
}

@end
