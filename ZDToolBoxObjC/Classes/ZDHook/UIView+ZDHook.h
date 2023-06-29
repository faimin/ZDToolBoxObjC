//
//  UIView+ZDHook.h
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2023/6/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZDHook)

/// Extend clickable area, e.g: self.zd_touchExtendInsets = UIEdgeInsetsMake(-10, -20, -40, -10);
@property (nonatomic, assign) UIEdgeInsets zd_touchExtendInsets;

@end

NS_ASSUME_NONNULL_END
