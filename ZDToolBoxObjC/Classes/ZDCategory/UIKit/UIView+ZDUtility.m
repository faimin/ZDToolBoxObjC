//
//  UIView+Utility.m
//  ZDToolBoxObjC
//
//  Created by Zero on 15/8/4.
//  Copyright (c) 2015年 Zero.D.Saber. All rights reserved.
//

#import "UIView+ZDUtility.h"
#import <objc/runtime.h>

static const void *CornerRadiusKey = &CornerRadiusKey;
static const void *TapGestureKey = &TapGestureKey;
static const void *TapGestureBlockKey = &TapGestureBlockKey;
static const void *LongPressGestureKey = &LongPressGestureKey;
static const void *LongPressGestureBlockKey = &LongPressGestureBlockKey;

#pragma mark - ZDLayoutGuideFrameObserver

static NSString *LayoutGuideKeyPath = @"layoutFrame";

@interface ZDLayoutGuideFrameObserver : NSObject
@property (nonatomic, weak) UILayoutGuide *layoutGuide;
@property (nonatomic, strong) NSMutableSet<dispatch_block_t> *onChanges;

- (instancetype)initWithLayoutGuide:(UILayoutGuide *)guide;
- (void)addFrameChange:(dispatch_block_t)block;

@end

@implementation ZDLayoutGuideFrameObserver

- (void)dealloc {
    if (!self.layoutGuide) {
        return;
    }
    @try {
        [self.layoutGuide removeObserver:self forKeyPath:LayoutGuideKeyPath context:nil];
    } @catch (NSException *exception) {
        NSLog(@"layouguide监听删除有异常 => %@", exception);
    } @finally {
        //
    }
}

- (instancetype)initWithLayoutGuide:(UILayoutGuide *)guide {
    if (self = [super init]) {
        _onChanges = [[NSMutableSet alloc] init];
        _layoutGuide = guide;
        [guide addObserver:self forKeyPath:LayoutGuideKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)addFrameChange:(dispatch_block_t)block {
    if (!block) {
        return;
    }
    [self.onChanges addObject:block];
}

#pragma mark - Private

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:LayoutGuideKeyPath]) {
        return;
    }
    for (dispatch_block_t block in self.onChanges) {
        block();
    }
}

@end

@implementation UIView (ZDUtility)

#pragma mark Controller

- (UIViewController *)zd_viewController {
	UIResponder *nextResponder = self;

	do {
		nextResponder = [nextResponder nextResponder];

		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	} while (nextResponder != nil);

	return nil;
}

- (UIViewController *)zd_topMostController {
	NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
	UIViewController *topController = self.window.rootViewController;

	if (topController) {
		[controllersHierarchy addObject:topController];
	}

	while ([topController presentedViewController]) {
		topController = [topController presentedViewController];
		[controllersHierarchy addObject:topController];
	}

	UIResponder *matchController = self.zd_viewController;

	while (matchController != nil && [controllersHierarchy containsObject:matchController] == NO) {
		do {
			matchController = [matchController nextResponder];
		} while (matchController != nil && ![matchController isKindOfClass:[UIViewController class]]);
	}

	return (UIViewController *)matchController;
}

#pragma mark Method

- (UIWindow *)zd_normalLevelWindow {
    UIWindow *targetWindow = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (targetWindow.windowLevel != UIWindowLevelNormal) {
        NSEnumerator<UIWindow *> *windows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                targetWindow = tempWindow;
                break;
            }
        }
    }
    return targetWindow;
}

- (void)zd_eachSubview:(void (^)(UIView *subview))block {
	NSParameterAssert(block != nil);
	[self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
		block(subview);
	}];
}

- (void)zd_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (BOOL)zd_isSubviewForView:(UIView *)superView {
    BOOL isSubview = ([self isDescendantOfView:superView] && ![self isEqual:superView]);
    return isSubview;
}

- (UIImage *)zd_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)zd_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    UIImage *screenshotImage = nil;
    if (@available(iOS 7.0, *)) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        screenshotImage = [self zd_snapshotImage];
    }
    return screenshotImage;
}

- (NSData *)zd_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData* data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)zd_roundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect frame = self.bounds;
    // NSAssert(!CGRectIsEmpty(frame), @"宽和高不能为0");
    if (CGRectIsEmpty(frame)) return;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame
                                                   byRoundingCorners:corners
                                                         cornerRadii:(CGSize){radius, radius}];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

- (void)zd_shake:(CGFloat)range {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[@(-range), @(range), @(-range/2), @(range/2), @(-range/5), @(range/5), @(0)];
    animation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:animation forKey:@"shake"];
}

/// Inspiration from ‘UITableView+FDTemplateLayoutCell’
- (CGFloat)zd_calculateDynamicHeightWithMaxWidth:(CGFloat)maxWidth {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat viewMaxWidth = maxWidth ? : CGRectGetWidth([UIScreen mainScreen].bounds);
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewMaxWidth];
    
    [self addConstraint:widthConstraint];
    CGSize fittingSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self removeConstraint:widthConstraint];
    
    return fittingSize.height;
}

+ (instancetype)zd_loadViewFromXib {
    NSString *className = NSStringFromClass(self);
    NSString *xibPatch =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.nib", className] ofType:nil];
    if (xibPatch) {
        return [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil].firstObject;
    }
    NSLog(@"\n\n不存在调用者class类型的xib文件\n");
    return nil;
}

#pragma mark Gesture

- (void)zd_addTapGestureWithBlock:(void(^)(UITapGestureRecognizer *tapGesture))tapBlock {
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, TapGestureKey);
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zd_handleTapAction:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, TapGestureKey, tap, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(tap, TapGestureBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (void)zd_addLongPressGestureWithBlock:(void(^)(UILongPressGestureRecognizer *longPressGesture))longPressBlock {
    UILongPressGestureRecognizer *longPress = objc_getAssociatedObject(self, LongPressGestureKey);
    if (!longPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zd_handleLongPressAction:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:longPress];
        objc_setAssociatedObject(self, LongPressGestureKey, longPress, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(longPress, LongPressGestureBlockKey, longPressBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark Private Method

- (void)zd_handleTapAction:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        void(^tapActionBlock)(UITapGestureRecognizer *) = objc_getAssociatedObject(tapGesture, TapGestureBlockKey);
        if (tapActionBlock) {
            tapActionBlock(tapGesture);
        }
    }
}

- (void)zd_handleLongPressAction:(UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateRecognized) {
        void(^longPressActionBlock)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(longPressGesture, LongPressGestureBlockKey);
        if (longPressActionBlock) {
            longPressActionBlock(longPressGesture);
        }
    }
}

#pragma mark - Layout

static void *LayoutGuideBindKey = &LayoutGuideBindKey;

- (void)zd_onLayout:(void(^)(UIView *))callback {
    if (!callback) {
        return;
    }
    
    __auto_type addGuideBlock = ^(UILayoutGuide *layoutGuide){
        [self addLayoutGuide:layoutGuide];
        [NSLayoutConstraint activateConstraints:@[
            [layoutGuide.widthAnchor constraintEqualToAnchor:self.widthAnchor],
            [layoutGuide.heightAnchor constraintEqualToAnchor:self.heightAnchor],
        ]];
    };
    
    UILayoutGuide *guide = objc_getAssociatedObject(self, _cmd);
    if (!guide) {
        guide = [[UILayoutGuide alloc] init];
        objc_setAssociatedObject(self, _cmd, guide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        addGuideBlock(guide);
        
        ZDLayoutGuideFrameObserver *ob = [[ZDLayoutGuideFrameObserver alloc] initWithLayoutGuide:guide];
        objc_setAssociatedObject(guide, LayoutGuideBindKey, ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (guide && guide.owningView != self) {
        if (guide.owningView) {
            [guide.owningView removeLayoutGuide:guide];
        }
        addGuideBlock(guide);
    }
    ZDLayoutGuideFrameObserver *observer = objc_getAssociatedObject(guide, LayoutGuideBindKey);
    __weak typeof(self) weakTarget = self;
    [observer addFrameChange:^{
        __strong typeof(weakTarget) self = weakTarget;
        callback(self);
    }];
}

@end

#pragma mark -
///========================================================

@implementation UIView (Frame)

#pragma mark Frame

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
	CGRect newFrame = self.frame;

	newFrame.origin = newOrigin;
	self.frame = newFrame;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
	CGRect newFrame = self.frame;

	newFrame.size = newSize;
	self.frame = newFrame;
}

#pragma mark Frame Origin

- (CGFloat)x {
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
	CGRect newFrame = self.frame;

	newFrame.origin.x = newX;
	self.frame = newFrame;
}

- (CGFloat)y {
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
	CGRect newFrame = self.frame;

	newFrame.origin.y = newY;
	self.frame = newFrame;
}

#pragma mark Frame Size

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
	CGRect newFrame = self.frame;

	newFrame.size.height = newHeight;
	self.frame = newFrame;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
	CGRect newFrame = self.frame;

	newFrame.size.width = newWidth;
	self.frame = newFrame;
}

#pragma mark Frame Borders

- (CGFloat)left {
	return self.x;
}

- (void)setLeft:(CGFloat)left {
	self.x = left;
}

- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
	self.x = right - self.width;
}

- (CGFloat)top {
	return self.y;
}

- (void)setTop:(CGFloat)top {
	self.y = top;
}

- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
	self.y = bottom - self.height;
}

#pragma mark Center Point

- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX {
	self.center = CGPointMake(newCenterX, self.center.y);
}

- (CGFloat)centerY {
	return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY {
	self.center = CGPointMake(self.center.x, newCenterY);
}

#pragma mark Middle Point

- (CGPoint)middlePoint {
	return CGPointMake(self.middleX, self.middleY);
}

- (CGFloat)middleX {
	return self.width * 0.5;
}

- (CGFloat)middleY {
	return self.height * 0.5;
}

#pragma mark - Chain Caller

- (UIView *(^)(CGFloat))zd_left {
    return ^UIView *(CGFloat left) {
        CGRect frame = self.frame;
        frame.origin.x = left;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_right {
    return ^UIView *(CGFloat right) {
        CGRect frame = self.frame;
        frame.origin.x = right - CGRectGetWidth(frame);
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_top {
    return ^UIView *(CGFloat top) {
        CGRect frame = self.frame;
        frame.origin.y = top;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_bottom {
    return ^UIView *(CGFloat bottom) {
        CGRect frame = self.frame;
        frame.origin.y = bottom - CGRectGetHeight(frame);
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_width {
    return ^UIView *(CGFloat width) {
        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_height {
    return ^UIView *(CGFloat height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_centerX {
    return ^UIView *(CGFloat centerX) {
        CGPoint center = self.center;
        center.x = centerX;
        self.center = center;
        return self;
    };
}

- (UIView *(^)(CGFloat))zd_centerY {
    return ^UIView *(CGFloat centerY) {
        CGPoint center = self.center;
        center.y = centerY;
        self.center = center;
        return self;
    };
}

- (UIView *(^)(CGPoint))zd_center {
    return ^UIView *(CGPoint center) {
        self.center = center;
        return self;
    };
}

- (UIView *(^)(CGPoint))zd_origin {
    return ^UIView *(CGPoint origin) {
        CGRect frame = self.frame;
        frame.origin = origin;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGSize))zd_size {
    return ^UIView *(CGSize size) {
        CGRect frame = self.frame;
        frame.size = size;
        self.frame = frame;
        return self;
    };
}

#pragma mark - Layer

- (void)setZd_cornerRadius:(CGFloat)zd_cornerRadius {
    objc_setAssociatedObject(self, CornerRadiusKey, @(zd_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //下面的方法只有获取到真实的bounds才有效
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:zd_cornerRadius];
    [maskPath addClip];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

- (CGFloat)zd_cornerRadius {
    return [objc_getAssociatedObject(self, CornerRadiusKey) floatValue];
}

@end
