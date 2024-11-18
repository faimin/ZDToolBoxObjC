//
//  UIView+ZDConstraint.h
//  ZDToolBoxObjC
//
//  Created by Zero_D_Saber on 2024/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZDConstraint)

/// find the contraint
- (nullable NSLayoutConstraint *)zd_constraintForAttribute:(NSLayoutAttribute)attribute;

- (void)zd_foldConstraint:(BOOL)fold attributes:(NSLayoutAttribute)attributes, ...NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
